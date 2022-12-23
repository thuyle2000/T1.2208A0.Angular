use db2208_A0
go

select * from tbEmployee
go

-- tao clustered index tren cot ho ten nhan vien
create clustered index ix_employee_name on tbEmployee(e_name)
go

-- them 3 nv voi 
insert tbEmployee values 
(N'Đỗ Anh Dũng', '2004-08-12',1, 1500),
(N'Lý Lan', '1958-02-12',0,3400),
(N'Đoàn Quỳnh Anh', '1963-05-24', 0, 2340)

-- xem ds nhan vien
select * from tbEmployee
go

-- xem danh sach cac mon hoc
select * from tbModule
go

-- tao index tren cot ten mon hoc
create index ix_module_name on tbmodule(module_name desc)
go

-- xem danh sach cac mon hoc
select * from tbModule
go

-- them 1 mon hoc moi
insert tbModule values ('M07','Design, Development DB', 8, 0)

-- them 1 mon hoc nua
insert tbModule values ('M06','XML and JSON', 20, 140)
go
 
-- tao 1 filter index tren cot hoc phi (dk so gio hoc >= 20)
create index ix_fee on tbModule(fee) where hours>=20
go