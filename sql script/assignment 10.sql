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
	MsgDetails DATE not null DEFAULT GETDATE(),
	[Status] VARCHAR(10) not null CHECK ([status] IN ('Pending', 'Resolved') )
)