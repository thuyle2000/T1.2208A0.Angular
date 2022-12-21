use db2208_A0
go

--1.  tao view chua thong tin cua cac nu sinh
create view vwShoolGirl AS
	select * from tbStudent where gender=0
go
-- test view 
select * from vwShoolGirl
go

--2. tao view chua thong tin nu sinh, co them cot tuoi va ten leader
-- cach 1: tao view tu bang student
create view vwShoolGirl_2 AS
	select sv.st_id, sv.st_name, sv.dob, 
		YEAR(GetDate())-YEAR(sv.dob) [age],
		sv.leader_id, tn.st_name [leader_name]
	from tbStudent [sv] left join tbStudent [tn]
						on sv.leader_id = tn.st_id
	where sv.gender=0
go

-- test view
select * from vwShoolGirl_2
go

-- cach 2: tao view tu view vwShoolGirl
create view vwShoolGirl_2x AS
	select sv.st_id, sv.st_name, sv.dob, 
		YEAR(GetDate())-YEAR(sv.dob) [age],
		sv.leader_id, tn.st_name [leader_name]
	from vwShoolGirl [sv] left join tbStudent [tn]
						on sv.leader_id = tn.st_id
go
-- test view
select * from vwShoolGirl_2x
go