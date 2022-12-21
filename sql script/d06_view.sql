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

--3. tao view chua ket qua thi, bao gom ten sv va ten mon hoc
create view vwExam AS
	select thi.id, thi.student [ma sv], sv.st_name [ho ten],
		   thi.module, mh.module_name [mon hoc], thi.mark 
	from tbStudentModule [thi] join tbStudent [sv] 
									on thi.student=sv.st_id
							   join tbModule [mh]
									on thi.module=mh.module_id
go
-- test view
select * from vwExam
go


--4. them du lieu: them 1 nu sinh vo view vwShoolGirl
insert vwShoolGirl values('S40','mimi', 0,'2006-12-25', 'S01')
-- xem ds nu sinh
select * from vwShoolGirl
go

--5. sua du lieu: doi ma so leader cua nu sinh Mimi thanh 'S11'
update vwShoolGirl
	set leader_id = 'S11', st_name='Alice'
	where st_id like 'S40'

 -- xem lai ds nu sinh
select * from vwShoolGirl
go

-- xem ds sinh vien
select * from tbStudent

--6. xoa du lieu: xoa nu sinh 'Alice'
delete from vwShoolGirl where st_name like 'Alice'
 -- xem lai ds nu sinh
select * from vwShoolGirl
go

--7. xem noi dung cua lenh tao view nu sinh
exec sp_helptext vwShoolGirl
exec sp_helptext vwShoolGirl_2
exec sp_helptext vwShoolGirl_2x


-- xem ds sinh vien
select * from tbStudent
-- xem ds nu sinh
select * from vwShoolGirl

--7. them 1 sinh vien nam vo view nu sinh
insert vwShoolGirl values
('S41','Vuong Nhat Bac',1, '2005-12-14','S01')
go

--8. neu ko muon nam sinh co the dc nhap vo database tu view nu sinh => them menh de 'WITH CHECK OPTION' cho dn view
alter view vwShoolGirl AS
	select * from tbStudent 
		where gender=0
		with check option
go
-- test cong dung cua 'with check option': them 1 sinh vien nam vo view nu sinh : LOI !!!
insert vwShoolGirl values
('S42','Chau Tinh Tri',1, '1962-06-22','S01')
go



-- xem ds nhan vien
select * from tbEmployee
go
--9. tao view nhan vien bao gom cac cot: ms, ten, ngay sinh, gioi tinh
create view vwEmployee 
with schemabinding as
select e_id [id], e_name [ho ten], 
		dob [ngay sinh], 
		case when gender=1 then 'nam'
			else 'nu'
		end [gioi tinh]
from dbo.tbEmployee
go
-- test view
select * from vwEmployee
go

-- test chuc nang 'with schemabinding' trong dn view: thu xoa bang nhan vien : LOI !!!
drop table tbEmployee
go
