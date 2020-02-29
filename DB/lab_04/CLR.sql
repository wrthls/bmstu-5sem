-- Создать, развернуть и протестировать 6 объектов SQL CLR:
EXEC sp_configure 'clr enabled', 1;  
RECONFIGURE;  
GO  

alter database VinylShop set trustworthy ON;

-- 1) Определяемую пользователем скалярную функцию CLR
-- Cчитает кол-во магазинов в базе
CREATE ASSEMBLY scalar FROM '\dll\scalar.dll'
GO

CREATE FUNCTION CountShops() RETURNS INT
AS EXTERNAL NAME scalar.T.ret;
GO  

SELECT dbo.CountShops();  
GO  

drop function CountShops
drop assembly scalar


-- 2) Пользовательскую агрегатную функцию CLR
-- Произведение рейтингов первых 5 магазинов
CREATE ASSEMBLY Mult FROM '\dll\mult.dll';  
GO
CREATE AGGREGATE Mult (@input int) RETURNS int
EXTERNAL NAME Mult.Mult;
 
SELECT dbo.Mult(A.Rating) from (select TOP(5) Rating from Shops) as A;  

drop aggregate Mult
drop assembly Mult
go

-- 3) Определяемую пользователем табличную функцию CLR
-- Степени числа 2 от 1 до а
CREATE ASSEMBLY power2 FROM '\dll\table.dll';  
GO

create function dbo.power2(@a int)
returns table (ID int)
as
external name power2.[pow2.TableValuedFunction].GenerateInterval
go

select * from dbo.power2(20)

drop function power2
drop assembly power2

-- 4) Хранимую процедуру CLR
-- Суммарный вес всех дисков
CREATE ASSEMBLY sum_weight FROM '\dll\proc.dll';  
GO

CREATE PROCEDURE SumWeight(@sum int OUTPUT)  
AS EXTERNAL NAME sum_weight.StoredProcedures.RamSum
Go

declare @rets int
exec SumWeight @rets output
select @rets


-- 5) Триггер CLR
-- Триггер удаления таблицы SDSH
CREATE ASSEMBLY sometrigger FROM '\dll\trigger.dll';  
GO

create trigger think on SDSH instead of delete as
EXTERNAL NAME sometrigger.CLRTriggers.DropTableTrigger
go

delete from SDSH where SDSHno = 2

select * from SDSH where SDSHno = 2

drop trigger think
drop assembly sometrigger


-- 6) Определяемый пользователем тип данных CLR.
CREATE ASSEMBLY point FROM '\dll\type.dll';  
GO

CREATE TYPE Point   
EXTERNAL NAME point.[Point];  


-- Тест пользовательского типа
CREATE TABLE dbo.Points 
( 
  id INT IDENTITY(1,1) NOT NULL, 
  point Point NULL 
);
GO

INSERT INTO dbo.Points(point) 
VALUES('-1,-2'),
	  ('1,1'),
	  ('1,5'),
	  ('5,6')
GO

select point.ToString() as points from Points
