USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'RK2')
DROP DATABASE RK2;
GO

CREATE DATABASE RK2;
GO

USE RK2;
GO

CREATE TABLE dbo.Excursion(
    Eid int IDENTITY(1,1) NOT NULL,
    Ename varchar (63) NOT NULL,
    Descript varchar(63) NULL,
    OpenDate date NULL,
    CloseDate date NULL,
);
GO

INSERT INTO Excursion (Ename, Descript, OpenDate, CloseDate)
VALUES ('AA', '00', '01.02.19', '01.02.20');
INSERT INTO Excursion (Ename, Descript, OpenDate, CloseDate)
VALUES ('AB', '01', '01.02.20', '01.02.21');
INSERT INTO Excursion (Ename, Descript, OpenDate, CloseDate)
VALUES ('BA', '10', '01.02.22', '01.02.23');
INSERT INTO Excursion (Ename, Descript, OpenDate, CloseDate)
VALUES ('BB', '11', '01.02.24', '01.02.25');
INSERT INTO Excursion (Ename, Descript, OpenDate, CloseDate)
VALUES ('AAA', '011', '01.02.25', '01.02.26');
INSERT INTO Excursion (Ename, Descript, OpenDate, CloseDate)
VALUES ('AAB', '100', '01.02.24', '01.02.26');
INSERT INTO Excursion (Ename, Descript, OpenDate, CloseDate)
VALUES ('ABA', '101', '01.02.15', '01.02.20');
INSERT INTO Excursion (Ename, Descript, OpenDate, CloseDate)
VALUES ('ABB', '110', '01.02.12', '01.02.26');
INSERT INTO Excursion (Ename, Descript, OpenDate, CloseDate)
VALUES ('BAA', '001', '01.02.25', '01.02.28');
INSERT INTO Excursion (Ename, Descript, OpenDate, CloseDate)
VALUES ('BAB', '010', '01.02.11', '01.02.23');
GO

SELECT * from Excursion;
GO


CREATE TABLE dbo.Guest(
    Gid int IDENTITY(1,1) NOT NULL,
    Gname varchar(63) NOT NULL,
    Adress varchar(63) NULL,
    PhoneNumber varchar(12) NULL,
);
GO

INSERT INTO Guest (Gname, Adress, PhoneNumber)
VALUES ('aa', 'Street 1', '111111');
INSERT INTO Guest (Gname, Adress, PhoneNumber)
VALUES ('ab', 'Street 2', '222222');
INSERT INTO Guest (Gname, Adress, PhoneNumber)
VALUES ('ba', 'Street 3', '33333');
INSERT INTO Guest (Gname, Adress, PhoneNumber)
VALUES ('bb', 'Street 4', '444444');
INSERT INTO Guest (Gname, Adress, PhoneNumber)
VALUES ('aaa', 'Street 5', '555555');
INSERT INTO Guest (Gname, Adress, PhoneNumber)
VALUES ('aab', 'Street 6', '666666');
INSERT INTO Guest (Gname, Adress, PhoneNumber)
VALUES ('aba', 'Street 7', '777777');
INSERT INTO Guest (Gname, Adress, PhoneNumber)
VALUES ('abb', 'Street 8', '8888888');
INSERT INTO Guest (Gname, Adress, PhoneNumber)
VALUES ('baa', 'Street 9', '9999999');
INSERT INTO Guest (Gname, Adress, PhoneNumber)
VALUES ('bab', 'Street 10', '0000000');
GO

SELECT * from Guest;
GO

CREATE TABLE dbo.Stand(
    [Sid] int IDENTITY(1,1) NOT NULL,
    Sname varchar(63) NOT NULL,
    SubjectArea varchar (63) NULL,
    Descript varchar (63) NULL
);
GO

INSERT INTO Stand (Sname, SubjectArea, Descript)
VALUES ('1', '11', '111');
INSERT INTO Stand (Sname, SubjectArea, Descript)
VALUES ('2', '22', '222');
INSERT INTO Stand (Sname, SubjectArea, Descript)
VALUES ('3', '33', '333');
INSERT INTO Stand (Sname, SubjectArea, Descript)
VALUES ('4', '44', '444');
INSERT INTO Stand (Sname, SubjectArea, Descript)
VALUES ('5', '55', '555');
INSERT INTO Stand (Sname, SubjectArea, Descript)
VALUES ('6', '66', '666');
INSERT INTO Stand (Sname, SubjectArea, Descript)
VALUES ('7', '77', '777');
INSERT INTO Stand (Sname, SubjectArea, Descript)
VALUES ('8', '88', '888');
INSERT INTO Stand (Sname, SubjectArea, Descript)
VALUES ('9', '99', '999');
INSERT INTO Stand (Sname, SubjectArea, Descript)
VALUES ('0', '00', '000');

SELECT * from Stand;
GO