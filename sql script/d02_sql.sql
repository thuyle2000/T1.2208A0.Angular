-- open database db2208_A0
use db2208_A0
go

-- xem/lietke/truy van ds tat ca cac sinh vien
select * from tbStudent

/* truy van du lieu voi cac vi tu LIKE, IN, BETWEEN */
-- tim cac sinh vien co ho 'vo' : ap dung vi tu (predicate) LIKE
select * from tbStudent where st_name LIKE 'vo%'

-- tim cac sv co ten dem la 'van'
select * from tbStudent where st_name LIKE '% van %'

-- tim cac sv co ten bat dau la chu 't'
-- in ra ten cua cac sinh vien
select *,LEN(st_name), LEN(st_name) - CHARINDEX(' ',REVERSE(st_name)) from tbStudent

select *,LEN(st_name), 
	LEN(st_name) - CHARINDEX(' ',REVERSE(st_name)), 
	SUBSTRING(st_name,LEN(st_name) - CHARINDEX(' ',REVERSE(st_name))+2, LEN(st_name))
from tbStudent




--tim cac sv sinh nam 2000-2003
select * from tbStudent where YEAR(dob)>=2000 and YEAR(dob)<=2003

--tim cac sv sinh nam 2000-2003: ap dung vi tu BETWEEN .. AND ..
select * from tbStudent where YEAR(dob) BETWEEN 2000 AND 2003

-- tim cac sv thuoc nhom cua leader co ma so 's01' va 's07'
select * from tbStudent 
	where leader_id LIKE 's01' OR leader_id LIKE 's07'
	      OR st_id LIKE 's01' OR st_id LIKE 's07'
-- tim cac sv thuoc nhom cua leader co ma so 's01' va 's07' : ap dung vi tu IN
select * from tbStudent 
	where leader_id IN ('s01','s07') OR st_id IN ('s01','s07')
GO

-- in ra ds sv 18 tuoi: ap dung cach khai bao bien
declare @year18 int
set @year18 = YEAR( GETDATE()) - 18

select * from tbStudent where YEAR(dob) = @year18
go

-- in ds sv 18 tuoi, voi cot gioi tinh mang gia tri hoac 'nam' hoac 'nu'
select * from tbStudent 
	where DATEDIFF(yy, dob, GETDATE()) = 18


select st_id [ma so], st_name [ho ten],
	   case 
			when gender = 1 then 'nam'
			else 'nu' 
	   end [gioi tinh],
	   dob [sinh nhat]
	from tbStudent 
	where DATEDIFF(yy, dob, GETDATE()) = 18

--in ra ds sinh vien co ngay sinh nhat trong thang hien tai
select * from tbStudent 
	where MONTH(dob) = MONTH(GETDATE())
 
