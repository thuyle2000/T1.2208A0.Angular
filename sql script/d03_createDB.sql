--1. tao csdl dbSample1
CREATE DATABASE dbSample1
GO

/*
  2. tao CSDL dbSample2 voi cac thong tin chi tiet :
  - tap tin data: dbSample2.MDF, kt ban dau: 10M, moi khi het dung luong, se tu dong tang them: 32M, kt toi da: ko gioi han

  - tap tin nhat ky: dbSample2_log.LDF, kt ban dau: 10M, he so tang: 10%, kt toi da: 64M

  - thu muc luu tru 2 tap tin nay: F:\DATA\
*/
 CREATE DATABASE dbSample2
	ON PRIMARY 
	(name='dbSample2', filename='F:\DATA\dbSample2.mdf', size=10, filegrowth=32, maxsize=unlimited)
	LOG ON
	(name='dbSample2_log', filename='F:\DATA\dbSample2_log.ldf', size=10, filegrowth=10%, maxsize=64)
GO

/*
  3. tao CSDL dbSample3 voi cac thong tin chi tiet :
  - tap tin data:
	 * file group [Primary]: dbSample3a.MDF, kt ban dau: 10M, moi khi het dung luong, se tu dong tang them: 32M, kt toi da: ko gioi han
     * file group [abc]: dbSample3b.NDF

  - tap tin nhat ky: dbSample3_log.LDF, kt ban dau: 10M, he so tang: 10%, kt toi da: 64M

  - thu muc luu tru 3 tap tin nay: F:\DATA\
*/
CREATE DATABASE dbSample3
	ON PRIMARY 
	(name='dbSample3a', filename='F:\DATA\dbSample3a.mdf', size=10, filegrowth=32, maxsize=unlimited),
	FILEGROUP ABC 
	(name='dbSample3b', filename='F:\DATA\dbSample3b.ndf')
	LOG ON
	(name='dbSample3_log', filename='F:\DATA\dbSample3_log.ldf')
GO

-- xoa CSDL dbSample2, dbSample3
DROP DATABASE dbSample2, dbSample3
GO

