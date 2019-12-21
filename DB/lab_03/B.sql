-- B. Четыре хранимых процедуры
-- 1. Хранимую процедуру без параметров или с параметрами
IF OBJECT_ID (N'dbo.getshops', 'P') is not null
drop procedure dbo.getshops;
go

create procedure getshops as 
begin 
select * from Shops
end; 
go

exec getshops;
go

-- 2. Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ
if OBJECT_ID (N'dbo.factorial', 'P') is not null
drop procedure dbo.factorial
go

create procedure dbo.factorial (@i int, @n float output)  
as
begin 
  if @n is null
    select @n = 1;

  if @i = 1 
    return;

  set @n = @n * @i;
  set @i = @i - 1;

  exec factorial @i, @n output
end
go

declare 
  @f float
begin
  exec factorial 5, @f output
  select @f as fib
end
go

-- 3. Хранимую процедуру с курсором
if OBJECT_ID (N'dbo.getsupliersnames', 'P') is not null
    drop procedure dbo.getsupliersnames;
go

create procedure getsupliersnames as 
begin
	declare c cursor for select Sname from Supliers
	declare @name nvarchar(63)
	open c

	declare @i int
	set @i = 0

	while (@i < 10)
	begin
		fetch next from c into @name
		print @name
        PRINT @i
		set @i = @i + 1
	end

	close c
	deallocate c

end;

exec getsupliersnames;
go


-- 4. Хранимую процедуру доступа к метаданным
if OBJECT_ID (N'dbo.checkExistingTables', 'P') IS NOT NULL
    drop procedure dbo.checkExistingTables
go

create procedure checkExistingTables as begin
	select name, create_date, modify_date from sys.tables
end
go

exec checkExistingTables
go