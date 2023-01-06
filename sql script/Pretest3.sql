create database dbPretest3
on primary 
(name='dbPretest3', filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\dbPretest3.mdf', size=5, maxsize=unlimited, filegrowth=20%)
log on
(name='dbPretest3_log', filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\dbPretest3_log.ldf', size=2, maxsize=50, filegrowth=10%)
go

use dbPretest3
go

create table tbEmpDetails
(
	Emp_Id varchar(5) primary key nonclustered,
	FullName varchar(30) not null,
	PhoneNumber varchar(20) not null,
	Desgination varchar(30) check (Desgination in ('Manager', 'Staff' )),
	Salary money check (Salary between 0 and 3000),
	Join_date date
)
go

create table tbLeaveDetails
(
	Leave_ID int identity,
	Emp_Id varchar(5) foreign key (Emp_Id) references tbEmpDetails (Emp_Id),
	LeaveTaken int check (LeaveTaken between 1 and 14),
	FromDate date,
	ToDate date,
	check (ToDate>FromDate),
	Reason varchar(50) not null,
	primary key nonclustered (Leave_ID)
)
go

insert tbEmpDetails values
('NV01','Nguyen Anh Duy','911','Manager',1246, '2022-01-06'),
('NV02','Le Thi Hoa Dang','112','Staff',2649, '2022-01-08'),
('NV03','Le Tan Kha','113','Staff',1469, '2022-01-10'),
('NV04','Bui Minh Hai','114','Staff',2778, '2022-01-12'),
('NV05','Tran Hong Duy Tu','986','Manager',2767, '2022-01-14')
go

insert tbLeaveDetails values
('NV01',13,'2022-01-01','2022-01-12','Ve que lay vo.'),
('NV02',4,'2022-01-08','2022-01-12','Benh sot.'),
('NV03',6,'2022-01-04','2022-01-10','Bi te xe.'),
('NV04',14,'2021-12-31','2022-01-13','Chuyen truong.'),
('NV05',5,'2022-01-16','2022-01-21','Buon thi nghi.')
go

-- xem lai bang tbEmpDetails va tbLeaveDetails
select * from tbEmpDetails
go

select * from tbLeaveDetails
go

create clustered index IX_Fullname on tbEmpDetails(Fullname)
go

create index IX_EmpID on tbLeaveDetails(Emp_Id)
go

create view vwManager
with encryption
as
	select b.FullName,a.*
	from tbLeaveDetails [a] join tbEmpDetails [b] on a.Emp_Id = b.Emp_Id where b.Desgination like 'Manager'
	with check option
go

select *from vwManager
go

sp_helptext vwManager
go

create proc uspChangeSalary
@amount int , @Empid varchar(5)
as
begin
			select * from tbEmpDetails
				where Emp_Id like @Empid
			update tbEmpDetails
				set Salary += @amount
				where Emp_Id like @Empid
			select * from tbEmpDetails
				where Emp_Id like @Empid
end
go

-- test case 1:
exec uspChangeSalary 200, 'NV03'
go

create trigger tgInsertLeave on tbLeaveDetails
for insert,update as
begin
	declare @sum_LeaveTaken int,@ma_nv varchar(5),@year int
	select @year=year(todate),@ma_nv=Emp_id from inserted
	select @sum_LeaveTaken=sum(LeaveTaken) from tbLeaveDetails where year(ToDate)=@year and emp_id=@ma_nv
	if @sum_LeaveTaken>15
	begin
		print 'Tong so ngay nghi cua cac nhan vien trong cung 1 nam da lon hon 15'
		rollback
	end
end
go

--test case1: thanh cong
set dateformat dmy
insert tbLeaveDetails values('N',5,'10-03-2021','15-03-2021','Bussy')
go
--test case2: that bai
set dateformat dmy
insert tbLeaveDetails values('E01',6,'10-04-2021','16-04-2021','Bussy')
go
--test case3: thanh cong
set dateformat dmy
insert tbLeaveDetails values('E01',6,'10-04-2022','16-04-2022','Bussy')
go
--test case4: that bai
set dateformat dmy
insert tbLeaveDetails values('E01',6,'10-05-2021','16-05-2021','Bussy')
go
update tbLeaveDetails set LeaveTaken=10 where Emp_id='E01'
go

delete from tbLeaveDetails where Emp_id='e02'
select * from tbLeaveDetails
go

create trigger tgUpdateEmploee on tbEmpDetails
for update as
	begin
		declare @newsalary int, @emp varchar(5)
		select @newsalary = Salary, @emp = Emp_Id from inserted
		if (@newsalary = 0)
			begin
				if ((select count(*) from tbLeaveDetails where Emp_Id = @emp) = 0 )
					begin
						delete from tbEmpDetails where Emp_Id like @emp
						print 'Da xoa nhan vien'
					end
			end
	end
go

select * from tbEmpDetails order by Emp_Id
select * from tbLeaveDetails order by Emp_Id
go

select * from tbEmpDetails order by Emp_Id
insert tbEmpDetails values
('NV06','Nguyen Thuy','986','Staff',2767, '2022-01-14')
go

--test case 1:
update tbEmpDetails set salary = 0 where Emp_Id = 'NV02'

--test case 2:
update tbEmpDetails set salary = 0 where Emp_Id = 'NV06'

--test case 3:
update tbEmpDetails set salary = 1000 where Emp_Id = 'NV02'