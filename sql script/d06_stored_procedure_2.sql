use db2208_A0
go

/* 
 1. viet stored procedure in ra danh sach sinh vien nam hoac nu hoac tat ca
 dua vao tham so input: 
	1 => in ds sv nam
	0 => in ds sv nu
	ko co tham so => in toan bo ds sinh vien
*/ 
create proc up_students
@option bit = null
as
begin
	if(@option is null)
		select * from tbStudent
	else
		select * from tbStudent where gender = @option

	select @@ROWCOUNT [so sinh vien]
end
go

--test case 1: in toan bo danh sach sv
exec up_students
go

--test case 2: in danh sach sv nam
exec up_students 1
go

--test case 3: in danh sach sv nu
exec up_students 0
go


/* 
 2. viet stored procedure in ra cap nhat lai luong cb cua nhan vien
 dua vao 2 tham so input: ten nv va muc luong dieu chinh
 va tra ve so luong nv (output) co muc luong dc dieu chinh
*/ 
create proc up_salary
@emp_name nvarchar(30), @salary int, @count_emp int OUTPUT
as
begin
	-- ds nhan vien se duoc dieu chinh luong
	select * from tbEmployee where e_name like '%'+@emp_name+'%'

	-- dieu chinh luong
	update tbEmployee 
		set salary = salary+ @salary 
		where e_name like '%'+@emp_name+'%'

	-- luu so luong nv da dieu chinh luong vo bien output 
	set @count_emp = @@ROWCOUNT
	
	-- ds nhan vien sau khi dieu chinh luong
	select * from tbEmployee where e_name like '%'+@emp_name+'%' 
end
go

-- test case 1: tang luong 100$ cho cac nv co ho Nguyen
declare @dem_nv int
exec up_salary N'Nguyễn', 100, @dem_nv OUTPUT
select @dem_nv [so luong nhan vien da duoc dieu chinh luong]
go


-- test case 2: giam luong 200$ voi nv co ten la Anh
declare @dem_nv int
exec up_salary N'Anh', -200, @dem_nv OUTPUT
select @dem_nv [so luong nhan vien da duoc dieu chinh luong]
go


