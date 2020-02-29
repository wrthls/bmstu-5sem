USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'RK3')
DROP DATABASE RK3;
GO

CREATE DATABASE RK3;
GO

USE RK3;
GO

CREATE TABLE dbo.Time(
    WorkerID int,
    Date date,
    WeekDay  varchar(20),
    Time time,
    Type int
);
GO

CREATE TABLE dbo.Workers(
    ID int IDENTITY(1,1) NOT NULL,
    WorkerName varchar (100) NOT NULL,
    BirthDay date,
    Department varchar(50)
);
GO

USE RK3;
GO

INSERT INTO dbo.Time VALUES
(1, CONVERT(DATETIME, '14-12-2018', 104), 'Суббота', CONVERT(TIME, '9:00'), 1),
(1, CONVERT(DATETIME, '14-12-2018', 104), 'Суббота', CONVERT(TIME, '9:20'), 2),
(1, CONVERT(DATETIME, '14-12-2018', 104), 'Суббота', CONVERT(TIME, '9:25'), 1),
(2, CONVERT(DATETIME, '14-12-2018', 104), 'Суббота', CONVERT(TIME, '9:05'), 1);
GO

INSERT INTO dbo.Workers VALUES
('Иванов Иван Иванович', CONVERT(DATETIME, '25-09-1990', 104), 'ИТ'),
('Петров Петр Петрович', CONVERT(DATETIME, '12-11-1987', 104), 'Бухгалтерия');
GO

SELECT * FROM [Time];
GO

SELECT * FROM Workers;
GO

CREATE FUNCTION dbo.CountLate (@on_time time, @date date)
RETURNS int AS

BEGIN
	DECLARE @ret int;
    SELECT @ret = COUNT(*) FROM(
        SELECT *, ROW_NUMBER() OVER(
            PARTITION BY WorkerID ORDER BY WorkerID
        ) AS n FROM(
            SELECT * FROM [Time]
            WHERE @date = [Date] AND [Type] = 1
            ) AS t1
    ) AS t2
    WHERE n = 1 and @on_time < [Time]

	RETURN @ret;
END;
GO

SELECT dbo.CountLate(CONVERT(TIME, '9:00'), CONVERT(DATETIME, '14-12-2018', 104));
GO

-- 2.1 Отделы, в которых сотрудник опаздывает больше 3х раз в неделю
WITH P1 AS (
            SELECT * FROM [Time]
            WHERE [Time] > CONVERT(time, '9:00') AND 
                [Type] = 1 AND
                Date BETWEEN CONVERT(DATETIME, '10-12-2018', 104) and CONVERT(DATETIME, '17-12-2018', 104)
        ), 
    P2 AS (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY WorkerID ORDER BY WorkerID) AS num
            FROM P1
        ),
    P3 AS (
            SELECT *
            FROM P2
            WHERE num >= 3 
        )
select Department
from P3 inner join Workers on P3.WorkerID = Workers.ID

-- 2.3
WITH P1 AS (
            SELECT *
            FROM [Time]
            WHERE [Type] = 1
        ),
    P2 AS (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY WorkerID ORDER BY WorkerID) as num
            FROM P1
        ),
    P3 AS (
            SELECT *
            FROM P2
            WHERE num = 1 and [Time] > CONVERT(time, '9:00')
        )
SELECT Department, count(*) OVER (PARTITION BY Department order by Department)
        FROM P3 INNER JOIN Workers ON P3.WorkerID = Workers.ID 