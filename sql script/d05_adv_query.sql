use db2208_A0
go

-- xem ds sinh vien
select * from tbStudent

-- dem so sinh vien theo nhom tuoi
select YEAR(dob) [nam sinh], count(*) [so luong sinh vien]
	from tbStudent group by YEAR(dob)

-- dem so sinh vien theo nhom tuoi, dk: sinh truoc nam 2004
select YEAR(dob) N'nam sinh', count(*) [so sinh vien] 
	from tbStudent
	where YEAR(dob)<2004
	group by YEAR(dob)

select YEAR(dob) N'nam sinh', count(*) [so sinh vien] 
	from tbStudent
	where YEAR(dob)<2004
	group by ALL YEAR(dob) 
go

-- dem so sv theo nhom tuoi, nhung chi lay ket qua cua cac nhom co tren 4 sinh vien
select YEAR(dob) N'nam sinh', count(*) [so sinh vien] 
	from tbStudent
	group by YEAR(dob) 
 
select YEAR(dob) N'nam sinh', count(*) [so sinh vien] 
	from tbStudent
	group by YEAR(dob) 
	having count(*) >=4
go  

-- xem ket qua thi cua sinh vien
select * from tbStudentModule order by module

-- tinh diem binh quan cua tung mon hoc
select module, avg(mark) [diem bq] from tbStudentModule 
	group by module
go

-- sua lai cau truc bang sinh vien: bo sung them cot so thu tu tang tu dong [id] va dinh nghia la khoa chinh
ALTER table tbStudentModule
	ADD id int identity(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
go

-- bo sung them diem thi
insert tbStudentModule(student, module, mark) values
('S02', 'M01', 60),
('S03', 'M01', 50),
('S03', 'M01', 75),
('S06', 'M01', 65),
('S06', 'M01', 80),
('S10', 'M01', 65),
('S10', 'M01', 20),
('S04', 'M02', 30),
('S04', 'M02', 55)

-- tinh diem binh quan cua tung sinh vien
select  student, module, 
	AVG(mark) [diem binh quan], count(*) [so lan thi]
	from tbStudentModule
	group by student, module

select  student, module, 
	AVG(mark) [diem binh quan], count(*) [so lan thi]
	from tbStudentModule
	group by student, module with cube

select  student, module, 
	AVG(mark) [diem binh quan], count(*) [so lan thi]
	from tbStudentModule
	group by student, module with rollup
go



-- chen them vai sinh vien sinh nam 2005
insert tbStudent values('S30','Messi', 1,'2005-01-31', null)
insert tbStudent values('S31','Ronaldo',1, '2005-02-28', 'S30')
insert tbStudent values('S32','Neymar',1, '2005-03-15', 'S30')
insert tbStudent values('S33','Lautaro Matinez',1, '2005-05-12', 'S30')
insert tbStudent values('S34','Kylian Mbappe',1, '2005-06-12', 'S30')
GO

-- tim cac sinh vien nho tuoi nhat
select * from tbStudent order by dob

-- tim nam sinh lon nhat => nho tuoi nhat
select max(YEAR(dob)) [nam sinh] from tbStudent 

select * from tbStudent 
		 where YEAR(dob) = (select max(YEAR(dob)) 
		                          from tbStudent);
go

-- bo sung them diem thi
insert tbStudentModule(student, module, mark) values
('S02', 'M03', 100),
('S02', 'M03', 25),
('S03', 'M02', 100),
('S06', 'M03', 25),
('S06', 'M03', 67),
('S30', 'M03', 100),
('S30', 'M03', 67),
('S30', 'M03', 90)

-- tim cac bai thi co diem cao nhat
select * from tbStudentModule order by mark desc
select * from tbStudentModule 
	where mark = (select max(mark) from tbStudentModule)

-- in ra ket qua thi bao gom cac cot:
-- ma so bai thi, ma sv, ten sv, gioi tinh, mon hoc, diem
select thi.id, sv.st_id, sv.st_name, sv.gender, thi.module, thi.mark 
from tbStudentModule [thi] join tbStudent [sv] on thi.student = sv.st_id


-- in ra ket qua thi bao gom cac cot:
-- ma so bai thi, ma sv, ten sv, gioi tinh, mon hoc, ten mon hoc, diem
select thi.id, sv.st_id, sv.st_name, sv.gender, thi.module, mh.module_name, thi.mark 
from tbStudentModule [thi] join tbStudent [sv] 
		on thi.student = sv.st_id 
						   join tbModule [mh]
		on thi.module = mh.module_id
go

-- xem ds cac mon hoc
select * from tbModule

-- xem ds cac mon hoc da to chuc thi
select distinct module from tbStudentModule

-- xem ds cac mon hoc chua co diem thi
select a.*, b.student, b.module, b.mark 
	from tbModule [a] left join tbStudentModule [b] 
		              on a.module_id = b.module
	where b.mark is null

select a.*
	from tbModule [a] left join tbStudentModule [b] 
		              on a.module_id = b.module
	where b.mark is null
go

-- xem ds sinh vien
select * from tbStudent
-- xem ds sinh vien, bao gom ten leader: self-join
select a.*, b.st_name [leader name] 
	from tbStudent [a] join tbStudent [b] 
					on a.leader_id = b.st_id

select a.*, b.st_name [leader name] 
	from tbStudent [a] left join tbStudent [b] 
					on a.leader_id = b.st_id
GO

-- xem ds sv thi du 2 mon c va thiet ke web
select distinct student, module from tbStudentModule 
	where module in('m01', 'm02')
	order by student
go

select distinct student 
		from tbStudentModule where module like 'm01'
intersect
select distinct student 
		from tbStudentModule where module like 'm02'
go

--lay ten sv du thi du 2 mon, ap dung bt CTE
with ds_thi as
(
	select distinct student 
			from tbStudentModule where module like 'm01'
	INTERSECT
	select distinct student 
			from tbStudentModule where module like 'm02'
)
select a.* 
	from tbStudent [a] join ds_thi [b] on a.st_id=b.student
go


-- xem ds sv thi mon c nhung ko thi thiet ke web
with ds_thi as
(
	select distinct student 
			from tbStudentModule where module like 'm01'
	EXCEPT
	select distinct student 
			from tbStudentModule where module like 'm02'
)
select a.* 
	from tbStudent [a] join ds_thi [b] on a.st_id=b.student
go