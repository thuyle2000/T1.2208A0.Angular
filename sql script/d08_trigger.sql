use db2208_A0
go


select * from tbStudentModule order by student, module
go

/*
viet trigger tren bang ket qua thi:
ko cho phep nhap diem cua 1 mon hoc qua 4 lan doi voi tung sv
-> loai trigger: insert, update 
*/
create trigger tg_mark on tbStudentModule
for insert, update as
begin
	declare @masv varchar(5), @mamh varchar(5)
	select @masv=student, @mamh=module from inserted
	select * from tbStudentModule 
			 where student like @masv and module like @mamh
    if @@ROWCOUNT >4 
	begin
		rollback	-- huy thao tac (undo) insert/update tren bang trigger (tbStudentModule)
		print 'Ko the nhap diem kq cua mon hoc tren 4 lan !'
	end	
end
go

--test case 1: them kq thi mon M01 cho sv S03: 45 diem -> thanh cong 
insert tbStudentModule values ('S03','M01', 45)
select * from tbStudentModule 
	where student like 'S03' and module like 'M01'
go

--test case 2: them kq thi mon M01 cho sv S03: 100 diem -> that bai ! 
insert tbStudentModule values ('S03','M01', 100)
select * from tbStudentModule 
	where student like 'S03' and module like 'M01'
go

--test case 2: doi kq thi mon M02 -> M01 cua sv S03 -> that bai ! 
update tbStudentModule set module='M01' 
	where student like 'S03' and module like 'M02'

select * from tbStudentModule 
	where student like 'S03' and module like 'M01'
go