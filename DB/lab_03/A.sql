-- Разработать и тестировать 10 модулей
-- A. Четыре функции
-- 1. Скалярную функцию (возвращает одно значение)
-- Поcчтитать кол-во магазинов с рейтингом r
IF OBJECT_ID(N'dbo.CountByRating', N'FN') IS NOT NULL
    DROP FUNCTION dbo.CountByRating;
GO

create function dbo.CountByRating (@r int)
returns int as

begin
	declare @ret int;
	select @ret = count(*) from dbo.Shops
	where Rating = @r
	return @ret;
end;
GO

select dbo.CountByRating(5) as cnt

-- 2. Подставляемую табличную функцию
-- Вывести информацию о магазине по номеру поставки
IF OBJECT_ID(N'dbo.GetBySDSHno') IS NOT NULL
    DROP FUNCTION dbo.GetBySDSHno;
GO

create function dbo.GetBySDSHno(@no int)
returns table as
	return
		(
			select * from dbo.Shops
			where SHno in
				(
					select SHno from dbo.SDSH
					where SDSHno = @no
				)
		)
go

select * from dbo.GetBySDSHno(3);

-- 3. Многооператорную табличную функцию
-- Вывести пары альбом-поставщик
IF OBJECT_ID (N'dbo.DiskSuplier', N'TF') IS NOT NULL
    DROP FUNCTION dbo.DiskSuplier
GO

create FUNCTION dbo.DiskSuplier()
returns @ret TABLE
(
    Album VARCHAR(63),
    Suplier VARCHAR(63)
)
AS
begin
    Insert into @ret
        SELECT Sname, Dalbum
        FROM
        SDSH JOIN Supliers on SDSH.Sno = Supliers.Sno 
        JOIN Disks on SDSH.Dno = Disks.Dno
RETURN
END;
GO

SELECT * from dbo.DiskSuplier();

--4. Рекурсивную функцию или функцию с рекурсивным ОТВ
-- Считает n-e число фибоначи 
IF OBJECT_ID(N'dbo.fib', N'FN') IS NOT NULL
    DROP FUNCTION dbo.fib;
GO

create function dbo.fib (@n int)
returns int as

begin
	if @n is NULL
		return NULL;
	if @n in (1,2)
		return 1
	return dbo.fib(@n-1) + dbo.fib(@n-2)
end
go

select dbo.fib(NULL) as fib

