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

