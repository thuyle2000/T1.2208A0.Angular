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
use ass1