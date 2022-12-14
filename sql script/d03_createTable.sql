--open CSDL db2208_A0
use db2208_A0
go

/* 1. tao bang nhan vien, bao gom cac cot:
	- e_id: ma nhan vien, so thu tu tang tu dong bat dau tu 1 (1,2,3,4...)
	- e_name: ho ten nhan vien (nhap ky tu unicode dc) : nvarchar(30)
	- dob : ngay sinh, date
	- gender: gioi tinh, bit (0,1)
	- salary: luong cb, int
*/
CREATE TABLE tbEmployee (
	e_id int identity(1,1) PRIMARY KEY nonClustered,
	e_name nvarchar(30) not null,
	dob date,
	gender bit not null,
	salary int
)
GO

-- nhap vai dong du lieu cho bang nhan vien
SET DATEFORMAT DMY
INSERT tbEmployee(e_name,dob,gender,salary ) VALUES
	(N'Nguyễn thi Giang','15-09-1988', 0, 1200 ),
	(N'Trần Đăng Khoa','24-12-1990', 1, 2100 )
SELECT * FROM tbEmployee
GO

SET DATEFORMAT DMY
INSERT tbEmployee VALUES
	(N'Nguyễn thi Kim Ngọc','03-04-1990', 0, 800 ),
	(N'Phạm Ngọc Thạch','22-08-1992', 1, 1700 ),
	(N'Trần Phú Phi','14-04-1998', 1, 1300 )
SELECT * FROM tbEmployee
GO

/*
2. sua lai cau truc bang nhan vien:
	bo sung them dinh nghia default cho cot gender = 1
*/
ALTER TABLE tbEmployee
	ADD CONSTRAINT df_gender DEFAULT 1 FOR Gender;
GO

SET DATEFORMAT DMY
INSERT tbEmployee(e_name,dob,salary ) VALUES
	(N'Nguyễn Anh Duy','02-11-2003',1200 )

SELECT * FROM tbEmployee
GO


/*
3. bo sung them 2 khoa ngoai (foreign key) cho cot ma sinh vien va ma mon hoc trong bang sinhvien dang ky mon hoc (tbStudentModule)
*/
ALTER TABLE tbStudentModule
	ADD CONSTRAINT fk_student FOREIGN KEY(student) REFERENCES tbStudent(st_id) ;

ALTER TABLE tbStudentModule
	ADD CONSTRAINT fk_module FOREIGN KEY(module) REFERENCES tbModule(module_id) ;
GO

/*
4. bo sung them rang buot kiem tra (check constraint) cho cot diem thi [0-100] trong bang sinhvien dang ky mon hoc (tbStudentModule)
*/
ALTER TABLE tbStudentModule
	ADD CONSTRAINT ck_mark CHECK ( mark BETWEEN 0 AND 100 )
GO

-- kiem tra xem dinh nghia check constraint tren cot diem co hoat dong ko ?
--1. xem ket qua diem thi
SELECT * FROM tbStudentModule 
--2. them 1 ket qua thi voi so diem la 101
INSERT tbStudentModule VALUES ('S21','M03', 101)  -- => LOI !!!
INSERT tbStudentModule VALUES ('S21','M03', 99)  -- => OK !
GO

/*
5. Thay doi (chinh sua) du lieu trong bang sinh vien
*/
--1. xem ds sinh vien
SELECT * FROM tbStudent

--2. doi ten cua sinh vien co ma so [s19] thanh [Nguyen thi thanh tuan]
UPDATE tbStudent 
	SET st_name = 'Nguyen thi Thanh Tuan'
	WHERE st_id LIKE 'S19'

--3. xem lai ds sinh vien
SELECT * FROM tbStudent
GO

/*  
	6. Xoa 1 so nhan vien trong bang nhan vien  
*/
--1. xem ds nhan vien
SELECT * FROM tbEmployee

--2. xoa cac nhan vien sinh nam 1990
DELETE FROM tbEmployee WHERE YEAR(dob) = 1990

--3. xem lai ds nhan vien
SELECT * FROM tbEmployee