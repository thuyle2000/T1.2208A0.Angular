use db2208_A0
go

select * from tbModule
go

begin transaction
	insert tbModule values ('M08','Java 1', 60, 170),
						   ('M09','Java 2', 56, 210)
	update tbModule set fee = 100 where module_id like 'M03'
rollback
go

select * from tbModule
go

