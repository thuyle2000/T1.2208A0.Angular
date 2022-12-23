use db2208_A0
go

select * from tbEmployee
go

-- tao clustered index tren cot ho ten nhan vien
create clustered index ix_employee_name on tbEmployee(e_name)
go
