CREATE DATABASE dbPretest4
	ON PRIMARY 
	(name='dbpretest4', filename='E:\DATA\dbPretest4.mdf.', size=8, filegrowth=20, maxsize=unlimited)
	LOG ON
	(name='dbpretest4_log', filename='E:\DATA\dbpretest4_log.ldf', size=8, filegrowth=10%, maxsize=50)
	
GO


drop database dbPretest4
go

use dbPretest4
go


create table tbStudents(
stID varchar(5) primary key  nonClustered,
stName varchar(50) not null,
stAge tinyint,
constraint stAge
check (stAge>= 14 and stAge<=70),
stGender bit default 1

)
go

create table tbProjects(
pID varchar(5) primary key nonClustered,
pName varchar(50) not null unique,
pType varchar(5),
constraint pType
check(pType='EDU' or pType='DEP' or pType ='GOV'),
Pstartdate date not null default getdate()


)
go

create table tbStudentProject(
studentId varchar(5) foreign key(studentId) references tbStudents(stID),
projectID varchar(5) foreign key(projectID) references tbProjects(pID),
joinedDate date not null default getdate(),
rate tinyint,
constraint rate
check( rate between 1 and 5),
primary key(studentId,projectId)

)
go


insert tbStudents values
('S01','Tom Hanks',18,1),
('S02','Phil Collins',18,1),
('S03','Jennifer Aniston',19,0),
('S04','Jane Fonda',20,0),
('S05','Cristiano Ronaldo',24,1)

select *from tbStudents
go

set dateformat dmy
insert tbProjects values
('P20','Social Network','GOV','12/01/2020'),
('P21','React Navtive + NodeJS','EDU','22/08/2020'),
('P22','Google Map API','DEP','15/10/2019'),
('P23','nCovid Vaccine','GOV','16/05/2020')

select *from tbProjects
go

set dateformat dmy
insert tbStudentProject values
('S01','P20','12/02/2020',4),
('S01','P21','12/03/2020',5),
('S02','P20','16/02/2020',3),
('S02','P22','01/09/2020',5),
('S04','P21','12/04/2020',4),
('S04','P22','01/10/2020',3),
('S04','P20','16/10/2020',3),
('S03','P23','04/07/2020',5)


select * from tbStudentProject
go


  create clustered index IX_stname on tbStudents(stName)
go

  create index IX_pID on tbStudentProject(projectID)

go


create view vwStudentPAroject
with encryption
as
select p.studentId,o.stName,o.stAge,r.pName,r.Pstartdate[startdate],p.joinedDate,p.rate
from tbStudentProject[p] join tbStudents[o] on p.studentId = o.stID
join tbProjects[r] on p.projectID = r.pID
	where r.Pstartdate < '2020-07-01'

 with check option


select * from vwStudentPAroject
go



--6
create proc upRating @avg_rate int output, @stName varchar(50)=null  as  
begin
	if @stName is null
	begin
		select s.*,p.pID,p.pName,sp.rate
		from tbStudentProject [sp]
			join tbStudents [s] on sp.studentID=s.stID
			join tbProjects [p] on sp.projectID=p.pID
		order by sp.studentID

		select @avg_rate = AVG(rate)
		from tbStudentProject
	end
	else
	begin
		select s.*,p.pID,p.pName,sp.rate
		from tbStudentProject [sp]
			join tbStudents [s] on sp.studentID=s.stID
			join tbProjects [p] on sp.projectID=p.pID
				where s.stName like'%'+ @stName + '%'

				--declare @avg_rate1 int
		select @avg_rate = AVG(rate)
		from tbStudentProject where @stName like '%' + @stName + '%'
	
	end
end
go

--test case 1
declare @tb int
exec upRating @tb output,'Tom Hanks'
select @tb [Average rate mark]
go

-- test case 2
declare @tb int
exec upRating @tb output
select @tb [Average rate mark]
go



--7
create trigger tgDeleteStudent on tbStudents
instead of delete as
begin
	delete from tbStudentProject where studentID in (select stID from deleted)
	delete from tbStudents where stID in (select stID from deleted)
end
go

delete from tbStudents where stID='S03'
select * from tbStudents
select * from tbStudentProject