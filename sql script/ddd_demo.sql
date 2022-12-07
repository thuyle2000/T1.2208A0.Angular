/* tao CSDL db2208_A0 : CREATE DATABASE */
create database db2208_A0
go

use db2208_A0
go

/* tao bang sinh vien : CREATE TABLE */
create table tbStudent
(
	st_id varchar(5) not null primary key,
	st_name varchar(30),
	gender bit not null default 1, --1:true,0:false
	dob date,
	leader_id varchar(5) 
)
go

/* tao bang mon hoc : CREATE TABLE */
create table tbModule
(
	module_id varchar(5) not null primary key,
	module_name varchar(50),
	[hours] tinyint,
	fee int
)
go

/*tao bang sinh vien dang ky mon hoc: CREATE TABLE */
create table tbStudentModule
(
	student varchar(5) not null,
	module varchar(5) not null,
	mark tinyint,
	primary key (student, module)
)
go

/* nhap du lieu vo bang mon hoc : INSERT tbModule VALUES () */
insert tbModule(module_id, module_name, [hours], fee) values
('M01', 'Lap trinh C co ban', 60, 200)

/* xem du lieu trong bang mon hoc: SELECT .. FROM .. */
select * from tbModule
GO

/* nhap 1 luc nhieu mon hoc vo bang mon hoc:
   INSERT tbModule VALUES (..), (..), (..), (..)
 */
 insert tbModule(module_id, module_name, [hours], fee) values
('M02', 'Thiet ke Web HTML5, CSS3, JS', 60, 240) ,
('M03', 'Angular/ AngularJS', 20, 120) ,
('M04', 'eProject Sem1', 40, 180) ,
('M05', 'Thiet ke CSDL', 12, 100) 
Go

/*xem lai ds cac mon hoc trong bang mon hoc : SELECT .. FROM .. */
select * from tbModule
GO



/* nhap du lieu vo bang sinh vien: INSERT tbStudent VALUES(...) */
set dateformat DMY
insert tbStudent VALUES
('S01','Nguyen Anh Duy',1, '30-04-2004',null)
select * from tbStudent
GO

set dateformat DMY
insert tbStudent VALUES
('S02','Le thi Hoa Dang',0, '25-12-2003','S01'),
('S03','Le Tan Kha',1, '14-10-2004','S01'),
('S04','Tran Ngoc Duy Tu',1, '13-08-2004',null),
('S05','Vo van Suong',1, '14-10-2004','S04'),
('S06','Vo Quang Trung',1, '11-06-2005','S04'),
('S07','Co Trinh Duy Tai',1, '11-10-2004',null),
('S08','Ho Vy Khang',1, '03-11-2003','S07'),
('S09','Cao Van Chien',1, '23-11-2003','S07'),
('S10','Nguyen Quang Hao',1, '17-12-2004','S07'),
('S11','Ly Hong Phong',1, '01-11-2003',null),
('S12','Duong Tuyet Mai',0, '14-10-2004','S11'),
('S13','Pham thi My Thuy',0, '08-05-2004','S11'),
('S14','Nguyen van The',1, '08-07-2004',null),
('S15','Nguyen van Quang',1, '04-08-2004','S14'),
('S16','Nguyen Huu Hao',1, '10-05-2004','S14'),
('S17','Le Duy Nien',1, '17-11-2004',null),
('S18','Nguyen Quoc Kiet',1, '17-11-2004','S17'),
('S19','Nguyen Thanh Tuan',1, '11-09-2000','S17'),
('S20','Nguyen Trinh Duy An',1, '18-09-2004',null),
('S21','Pham Duy Khuong',1, '01-01-2004','S20')
Go

select * from tbStudent
Go

/* xem du lieu cua bang sinh vien-mon hoc : SELECT ... FROM ... */
select * from tbStudentModule
/* them du lieu vo bang sinhvien - monhoc : INSERT ... */
insert tbStudentModule VALUES
('S01','M01', 70),
('S02','M01', 70),
('S03','M01', 70),
('S04','M01', 80),
('S05','M01', 70),
('S06','M01', 60),
('S07','M01', 70),
('S08','M01', 70),
('S09','M01', 75),
('S10','M01', 70),
('S20','M01', 100),
('S01','M02', 39),
('S20','M02', 30),
('S21','M02', 58),
('S12','M02', 30),
('S16','M02', 60),
('S15','M02', 65),
('S14','M02', 35),
('S13','M02', 80)
go


/*xem ds tat ca sinh vien */
select * from tbStudent

/* xem ds sinh vien nu: SELECT .. FROM .. WHERE gender=0 */
select * from tbStudent where gender=0

/* xem ds sinh vien co ho 'nguyen' : SELECT.. FROM .. WHERE LIKE */
select * from tbStudent where st_name LIKE 'nguyen%'

/* xem ds sv co ten 'Hao': SELECT .. FROM.. WHERE */
select * from tbStudent where st_name LIKE '% hao'

/* xem ds sv, xep thu thu theo ngay sinh nhat*/
select * from tbStudent order by dob
select * from tbStudent 
	order by dob desc -- thu tu giam dan: tuoi nho->lon

/* tim ngay sinh nhat lon nhat */
select max(dob) [ngay sinh] from tbStudent

/* tim sv nho tuoi nhat : truy van con */
select * from tbStudent 
	where dob = (select max(dob) from tbStudent)
go

/* dem so sinh vien nam, sinh vien nu */
select gender, count(*) from tbStudent
	group by gender

select gender, count(*) [So sinh vien] from tbStudent
	group by gender

select case gender
			when 1 then 'nam'
			else 'nu'
	   end [gioi tinh], 
	count(*) [so sinh vien] from tbStudent
	group by gender
go

/* dem sinh vien theo nam sinh */
select count(*) [so sinh vien] from tbStudent
	group by year(dob)

select year(dob), count(*) [so sinh vien] from tbStudent
	group by year(dob)

select year(dob) [nam sinh], count(*) [so sinh vien] from tbStudent
	group by year(dob)

select year(dob) [nam sinh], count(*) [so sinh vien] from tbStudent
	group by year(dob)
	order by year(dob)


select year(dob) [nam sinh], count(*) [so sinh vien] from tbStudent
	group by year(dob)
	having count(*) >3 --chi lay nhom co tren 3 sinh vien
	order by year(dob)
go


/* xem bang diem sinh vien */
select * from tbStudentModule

select tbStudentModule.*, tbStudent.st_name 
	from tbStudentModule join tbStudent on st_id = student

select a.*, b.st_name 
	from tbStudentModule [a] join tbStudent [b] on b.st_id = a.student

select a.*, b.st_name, c.module_name 
	from tbStudentModule [a] 
			join tbStudent [b] on b.st_id = a.student
			join tbModule [c] on c.module_id = a.module
go

select a.*, b.st_name, c.module_name 
	from tbStudentModule [a] 
			join tbStudent [b] on b.st_id = a.student
			join tbModule [c] on c.module_id = a.module
	order by a.student
go

select a.*, b.st_name, c.module_name 
	from tbStudentModule [a] 
			join tbStudent [b] on b.st_id = a.student
			join tbModule [c] on c.module_id = a.module
	order by a.student
go

select a.*, b.st_name, c.module_name 
	from tbStudentModule [a] 
			join tbStudent [b] on b.st_id = a.student
			join tbModule [c] on c.module_id = a.module
	order by a.module

select a.*, b.st_name, c.module_name 
	from tbStudentModule [a] 
			join tbStudent [b] on b.st_id = a.student
			join tbModule [c] on c.module_id = a.module
	order by a.module, a.mark desc