create database dbPretest
go

use dbPretest
go

create table tbRoom
(
	RoomNo int primary key nonclustered,
	[Type] varchar(20) check ([Type] in ('VIP', 'Double', 'Single')),
	UnitPrice Money check (UnitPrice between 0 and 1000)
) 
go

create table tbBooking
(
	BookingNo int ,
	RoomNo int foreign key (RoomNo) references tbRoom(RoomNo),
	TouristName varchar(20) not null,
	DateFrom date,
	DateTo date ,
	check (DateTo>DateFrom),
	primary key nonclustered (BookingNo, RoomNo) 
) 
go


insert tbRoom values
(101,'Single',100),
(102,'Single',100),
(103,'Double',250),
(201,'Double',250),
(202,'Double',300),
(203,'Single',150),
(301,'VIP',900)
go

set dateformat DMY
insert tbBooking values 
(1,101,'Julia','12-11-2020','14-11-2020'),
(1,103,'Julia','12-12-2020','13-12-2020'),
(2,301,'Bill','10-01-2021','14-01-2021'),
(3,201,'Ana','12-01-2021','14-01-2021'),
(3,202,'Ana','12-01-2021','14-01-2021')
go

create clustered index IxName on tbBooking(TouristName)
go

create index ixType on tbRoom([Type])
go

create view vwBooking 
with encryption
as
	select  b.BookingNo, b.TouristName, a.RoomNo, a.Type,	   a.UnitPrice, b.DateFrom, b.DateTo
			from tbRoom [a]
			join tbBooking [b]
			  on a.RoomNo =  b.RoomNo
go

sp_helptext vwBooking
go

select * from vwBooking
go

create proc uspPriceDecrease
@amount int = null
as
begin
	if (@amount is null)
		begin
			select * from tbRoom 
				order by UnitPrice
		end
	else 
		begin
			select * from tbRoom
				where [Type] like 'Double'
			update tbRoom
				set UnitPrice -= @amount
				where [Type] like 'Double'
			select * from tbRoom
				where [Type] like 'Double'
		end
end
go

--test case 1:
exec uspPriceDecrease
go

--test case 2:
exec uspPriceDecrease 20
go

create proc uspSpecificPriceIncrease 
@RoomId int, @amount int, @count250 int output
as
begin
	select * from tbRoom
		where RoomNo = @RoomId
	update tbRoom
		set UnitPrice += @amount
		where RoomNo = @RoomId
	select * from tbRoom
		where RoomNo = @RoomId

	-- count
	select @count250=count(*) from tbRoom
		where UnitPrice >= 250
end
go

--test case 1:
declare @count250 int 
exec uspSpecificPriceIncrease 101, 30, @count250 output
select @count250 [so phong tren 250]
go

create trigger tgBookingRoom on tbBooking
for insert, update as 
	begin
		declare @total int 
		select @total=count(*) from tbBooking
			where BookingNo = (select BookingNo from inserted)
		if @total > 3 
			begin
				print 'ko the order hon 3 phong'
				rollback
			end
	end
go

--test case 1:
set dateformat DMY
insert tbBooking values
(1, 201, 'Julia', '12-11-2020', '15-11-2020')
go

select * from tbBooking
go

--test case 2:
set dateformat DMY
insert tbBooking values
(1, 202, 'Julia', '12-11-2020', '15-11-2020')
go

create trigger tgRoomUpdate on tbRoom
for insert, update as
	begin
		declare @newPrice int, @room int
		select @newPrice = Unitprice, @room = RoomNo from inserted
		if (@newPrice=0)
			begin 
				if ((select count(*) from tbBooking where RoomNo = @room) > 0 )
					begin
						print 'ko the thay doi gia phong'
						rollback
					end
				else 
					begin
						delete from tbRoom where RoomNo = @room
						print 'Da xoa phong'
					end
			end
	end
go

select * from tbBooking order by RoomNo
select * from tbRoom 
go

--test casse 1:
update tbRoom
set UnitPrice = 200
	where RoomNo = 101
go

--test casse 2:
update tbRoom
set UnitPrice = 0
	where RoomNo = 101
go

--test casse 3:
update tbRoom
set UnitPrice = 0
	where RoomNo = 102
go