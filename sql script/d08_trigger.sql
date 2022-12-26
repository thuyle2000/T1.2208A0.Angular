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


/*
2. viet trigger tren bang nhan vien: khong cho phep thay doi ma so nv
	-> loai trigger: update
*/
create trigger tg_employee on tbEmployee
after update as
begin
	if update(e_id)
	begin
		rollback -- huy thao tac update
		print 'Ko duoc phep doi ma so nhan vien'
	end
end
go

--test case 1: doi luong cua nv co ms = 8, thanh 4300
select * from tbEmployee
update tbEmployee set salary=4300 where e_id=8
select * from tbEmployee
go

/*
3. sua lai trigger tren bang nv: khong cho phep thay doi ten nv
	-> loai trigger: update
*/
alter trigger tg_employee on tbEmployee
after update as
begin
	if update(e_name)
	begin
		rollback -- huy thao tac update
		print 'Ko duoc phep doi ten nhan vien'
	end
end
go

--test case 2: doi ten cua nv co ms 8-> 'Lyly' : Loi !
select * from tbEmployee
update tbEmployee set e_name='Lyly' where e_id=8
select * from tbEmployee
go

/*
4. viet trigger tren bang nhan vien: khong cho phep xoa nhan vien co ten la Duy
	-> loai trigger: delete
*/
create trigger td_delete_employee on tbEmployee
for delete as
begin
	select * from deleted where e_name like N'% duy'
	if @@ROWCOUNT > 0
	begin
		rollback -- huy thao tac delete
		print 'Ko duoc phep xoa nhan vien co ten la Duy'
	end
end
go

-- test case 1: xoa nhan vien co ten la Anh
select * from tbEmployee
delete from tbEmployee where e_name like '% anh' 

-- test case 2: xoa nhan vien co ten la duy : Loi !!!
select * from tbEmployee
delete from tbEmployee where e_name like '% duy' 
go

/*
5. viet trigger tren bang sinh vien: 
   neu xoa 1 sv, thi phai xoa luon ket qua thi cua sinh vien do
	-> loai trigger: instead of delete
*/
create trigger tg_student_remove on tbStudent
instead of delete as
begin
	--1. xoa diem thi cua sinh vien trong bang deleted
	delete from tbStudentModule 
		where student in (select st_id from deleted)

	--2. xoa sinh vien trong bang deleted
	delete from tbStudent
		where st_id in (select st_id from deleted)
end
go

-- test case: xoa sv co ma so s41
select * from tbStudent
delete from tbStudent where st_id like 's41'
go

-- xem dinh nghia cua trigger [td_delete_employee]
sp_helptext td_delete_employee
go


-- tao synonym [dbo].[sinhvien], la ten khac cua bang [tbStudentModule]
CREATE SYNONYM [dbo].[sinhvien] 
FOR [db2208_A0].[dbo].[tbStudentModule]
GO

-- xem ds sinh vien
select * from tbStudentModule
select * from dbo.sinhvien

-- vi du ve window over
select * from tbStudentModule

select student, module, 
	AVG(mark) over (partition by student, module) [diem BQ]
 from tbStudentModule
