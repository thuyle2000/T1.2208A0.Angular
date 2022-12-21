use db2208_A0
go

/* 
	1. tao stored procedure de thuc hien 2 viec:
		- xem danh sach cac nu sinh
		- dem so luong nu sinh 
*/
create proc up_shoolGirl AS
begin
	--1. xem ds nu sinh
	select sv.st_id, sv.st_name, sv.dob, 
			YEAR(GetDate())-YEAR(sv.dob) [age],
			sv.leader_id, tn.st_name [leader_name]
		from tbStudent [sv] left join tbStudent [tn]
						on sv.leader_id = tn.st_id
		where sv.gender=0

	--2. dem so nu sinh
	select @@ROWCOUNT [so nu sinh] -- @@ROWCOUNT : tra ve so dong bi tac dong cua cau lenh truoc (xem ds nu sinh)

end
go
-- test case : goi store, de xem ds nu sinh va so luong nu sinh
exec up_shoolGirl
go

-- xem ds cac mon hoc
select * from tbModule
go
/* 
	2. tao stored procedure de thuc hien 4 viec:
		- xem danh sach cac mon hoc
		- tang hoc phi moi mon hoc len 10%
		- xem lai danh sach cac mon hoc
		- in ra mon hoc co hoc phi cao nhat
*/
create proc up_module AS
begin
	--1/ xem danh sach cac mon hoc
	select * from tbModule
	--2/ tang hoc phi moi mon hoc len 10%
	update tbModule set fee = fee*110/100
	--3/ xem danh sach cac mon hoc sau khi tang hoc phi
	select * from tbModule
	--4/ in ra mon hoc co hoc phi cao nhat
	select top 1 * from tbModule Order by fee desc
end
go
--test case: goi store de tang hoc phi cac mon hoc
exec up_module
go