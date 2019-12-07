USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'VinylShop')
DROP DATABASE VinylShop;
GO

/* CREATE DATABASE */
CREATE DATABASE VinylShop;
GO

/* CHANGE TO VINYLSHOP DATABASE */
USE VinylShop;
GO

/* CREATE SUPLIERS TABLE */
CREATE TABLE dbo.Supliers(
    Sno int IDENTITY(1,1) NOT NULL,
    Sname varchar (63) NOT NULL,
    City varchar (63) NULL
);
GO

/* CREATE DISKS TABLE */
CREATE TABLE dbo.Disks(
    Dno int IDENTITY(1,1) NOT NULL,
    Dalbum varchar(63) NOT NULL,
    Artist varchar(63) NULL,
    Genre varchar(63) NULL,
    Weight int NULL
);
GO

/* CREATE SHOPS TABLE */
CREATE TABLE dbo.Shops(
    SHno int IDENTITY(1,1) NOT NULL,
    SHname varchar(63) NOT NULL,
    City varchar (63) NULL,
    Rating smallint NULL
);
GO

/* CREATE TABLE OF SUPLIES */
CREATE TABLE dbo.SDSH(
    SDSHno int IDENTITY(1,1) NOT NULL,
    Sno int NOT NULL,
    Dno int NOT NULL,
    SHno int NOT NULL,
    Qty int NULL
);
GO
