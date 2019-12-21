-- CLR on
EXEC sp_configure 'clr enabled', 1;  
RECONFIGURE;  
GO  

alter database VinylShop set trustworthy ON;

-- Scalar CLR

CREATE ASSEMBLY scalar FROM 'C:\Users\Dmitry\git\Databases\lab04\cs\scalar.dll'
GO

CREATE FUNCTION CountShops() RETURNS INT
AS EXTERNAL NAME scalar.T.ret;
GO  

SELECT dbo.CountShops();  
GO  

drop function CountShops
drop assembly scalar


-- Agr CLR

CREATE ASSEMBLY Mult FROM 'C:\Users\Dmitry\git\Databases\lab04\cs\Mult.dll';  
GO
CREATE AGGREGATE Mult (@input int) RETURNS int
EXTERNAL NAME Mult.Mult;
 
SELECT dbo.Mult(A.Rating) from (select TOP(5) Rating from Shops) as A;  

drop aggregate Mult
drop assembly Mult
go

-- Table CLR

CREATE ASSEMBLY power2 FROM 'C:\Users\Dmitry\git\Databases\lab04\cs\table.dll';  
GO

create function dbo.power2(@a int)
returns table (ID int)
as
external name power2.[pow2.TableValuedFunction].GenerateInterval
go

select * from dbo.power2(20)

drop function power2
drop assembly power2

-- proc CLR

CREATE ASSEMBLY sumweight FROM 'C:\Users\Dmitry\git\Databases\lab04\cs\proc.dll';  
GO

CREATE PROCEDURE RamSum (@sum int OUTPUT)  
AS EXTERNAL NAME sumweight.StoredProcedures.RamSum
Go

declare @rets int
exec RamSum @rets output
select @rets


-- trigger CLR

CREATE ASSEMBLY sometrigger FROM 'C:\Users\Dmitry\git\Databases\lab04\cs\trigger.dll';  
GO

create trigger think on SDSH instead of delete as
EXTERNAL NAME sometrigger.CLRTriggers.DropTableTrigger
go

delete from SDSH where SDSHno = 1

select * from SDSH where SDSHno = 1

drop trigger think
drop assembly sometrigger


-- type CLR

CREATE ASSEMBLY point FROM 'C:\Users\Dmitry\git\Databases\lab04\cs\type.dll';  
GO

CREATE TYPE Point   
EXTERNAL NAME point.[Point];  


-- type test
CREATE TABLE dbo.Points 
( 
  id INT IDENTITY(1,1) NOT NULL, 
  point Point NULL 
);
GO

INSERT INTO dbo.Points(point) 
VALUES('0,0'),
	  ('1,1'),
	  ('1,5'),
	  ('5,6')
GO

select point.ToString() from Points
