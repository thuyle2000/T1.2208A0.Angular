-- assignment 10
/*
Create a database named Ass10_Db with the following specifications :
a. Primary file group with the data file Ass10.mdf. The size, maximum size, and file growth should be 5, 50 and 10% respectively.
b. File group Group1 with the data file Ass10_1.ndf. The size, maximum size, and file growth should be 10, unlimited, and 5 respectively.
c. Log file Ass10_log.ldf. The size, maximum size, and file growth should be 2, unlimited, and 10% respectively.

*/

create database Ass10_Db 
on primary 
(name='ass10', filename='F:\data\ass10.mdf', size=5, maxsize=50, filegrowth=10%),
filegroup Group1 
(name='ass10_1', filename='F:\data\ass10_1.ndf', size=10, maxsize=unlimited, filegrowth=5)
log on
(name='ass10_log', filename='F:\data\ass10_log.ldf', size=10, maxsize=unlimited, filegrowth=10%)
go

-- open db
use Ass10_Db
go

/*
Table: tbCustomer
Column Names Data type Description
CustCode VARCHAR(5) Customer Code – PRIMARY KEY
CustName VARCHAR(30) Customer Name – NOT NULL
CustAddress VARCHAR(50) Customer Address – NOT NULL
CustPhone VARCHAR(15) Customer Phone
CustEmail VARCHAR(25) Email address of customer
CustStatus VARCHAR(10) Status of the Customer either Valid or Invalid, default value is Valid
*/
create table tbCustomer (
	CustCode VARCHAR(5) not null primary key nonclustered,
	CustName VARCHAR(30) not null,
	CustAddress VARCHAR(50) not null,
	CustPhone VARCHAR(15),
	CustEmail VARCHAR(25),
	CustStatus VARCHAR(10) not null DEFAULT 'Valid'
					CHECK( CustStatus in ('Valid','Invalid') )
)
go

/*
Table: tbMessage
Column Names Data type Description
MsgNo INTEGER Customer message number – identity (1000,1) - PRIMARY KEY
CustCode VARCHAR(5) Customer Code – FOREIGN KEY REF
MsgDetails VARCHAR(300) Customer message details – NOT NULL
MsgDate DATETIME Date of message – NOT NULL, default value is current date
Status VARCHAR(10) Status of message either Pending or Resolved
*/
create table tbMessage (
	MsgNo int identity(1000,1) primary key NONCLUSTERED,
	CustCode VARCHAR(5) FOREIGN KEY References tbCustomer(CustCode),
	MsgDetails VARCHAR(300) not null,
	MsgDate DATE not null DEFAULT GETDATE(),
	[Status] VARCHAR(10) not null CHECK ([status] IN ('Pending','Resolved') )
)
GO

-- insert data 
/*
tbCustomer
CustCode CustName CustAddres CustPhone CustEmail CustStatus
C001 Rahul Khana 7th Cross Road 298345878 khannar@hotmail.com Valid
C002 Anil Thakkar Line Ali Road 657654323 Thakkar2002@yahoo.com Valid
C004 Sanjay Gupta Link Road 367654323 SanjayG@indiatimes.com Invalid
C005 Sagar Vyas Link Road 376543255 Sagarvyas@india.com Valid
*/
insert tbCustomer values
('C001', 'Rahul Khana', '7th Cross Road', '298345878', 'khannar@hotmail.com', 'Valid'),
('C002', 'Anil Thakkar', 'Line Ali Road', '657654323', 'Thakkar2002@yahoo.com', 'Valid'),
('C004', 'Sanjay Gupta', 'Link Road', '367654323', 'SanjayG@indiatimes.com', 'Invalid'),
('C005', 'Sagar Vyas', 'Link Road', '376543255', 'Sagarvyas@india.com', 'Valid')
go

/*
tbMessage
MsgNo CustCode MsgDetails MsgDate Status
1000 C001 Voice mail always give ACCESS DENIED message 31-Aug-2014 Pending
1001 C005 Voice mail activation always give NO ACCESS message 1-Sep-2014 Pending
1002 C001 Please send all future bill to my residential address instead of my office address 5-Sep-2014 Resolved
1003 C004 Please send new monthly brochure ... 8-Nov-2014 Pending
*/
set dateformat dmy
insert tbMessage values
('C001', 'Voice mail always give ACCESS DENIED message', '31-08-2014', 'Pending'),
('C005', 'Voice mail activation always give NO ACCESS message', '01-09-2014', 'Pending'),
('C001', 'Please send all future bill to my residential address instead of my office address', '05-09-2014', 'Resolved'),
('C004' ,'Please send new monthly brochure ...', '08-11-2014', 'Pending')
go

/*
4. 
a. Create a clustered index IX_Name for CustName column on tbCustomer table.
b. Create a composite index IX_CustMsg fot CustCode and MsgNo columns on tbMessage table
*/
create clustered index IX_Name on tbCustomer(CustName)
create index IX_CustMsg on tbMessage (CustCode,MsgNo) 
go

/*
5. Write a query to display the list of customers have no message sent yet.
*/
select * from tbCustomer 
	where CustCode not in (select distinct CustCode from tbMessage)
go

/*
6. Create a view vReport which displays messages sended after 1 – Sep – 2014 as following:
		MsgNo MsgDetails DatePosted PostedBy Status
		1002 Please send all ... 09/05/2014 RahulKhana Resolved
		1003 Please send new... 11/08/2014 Sanjay Gupta Pending
	Note: The definition of view must be hidden from users.
*/
create view vReport with encryption as 
	select MsgNo, MsgDetails, MsgDate [Date posted], b.CustName [Posted by], Status 
	from tbMessage a join tbCustomer b on a.CustCode = b.CustCode
	where MsgDate >= '2014-09-01'
go

-- test view vReport
select * from vReport
go

/*
7. Create a store procedure uspChangeStatus to modify CustStatus column in Customer table from “invalid” to “valid” and display the number of records were changed.
*/
create proc uspChangeStatus as
begin
	update tbCustomer set CustStatus = 'valid' where CustStatus='invalid'
	select @@ROWCOUNT [so dong da thay doi trang thai]
end
go

-- test procedure
exec uspChangeStatus
go



	