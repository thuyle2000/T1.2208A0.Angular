use db2208_A0
go

/* 1. viet stored procedure in ra danh sach sinh vien nam hoac nu hoac tat ca
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
