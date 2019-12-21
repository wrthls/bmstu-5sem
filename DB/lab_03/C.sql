-- C. Два DML триггера
-- 1. Триггер AFTER
DROP TABLE History;

create table History 
(
    Id int identity primary key,
    SHno int NOT NULL,
    SHname nvarchar(50) NOT NULL
);
go

create or ALTER trigger newshop on Shops after insert as
insert into History (SHno, SHname)
select SHno, 'THIS_IS_' + SHname
from inserted;
GO

insert into Shops(SHname) values ('SHOP_NAME');
GO

select * from History;
go

-- 2. Триггер INSTEAD OF
create trigger donot on SDSH instead of delete as
print 'PLEASE, DO NOT';
GO

select * from SDSH where SDSHno = 1;
GO

delete from SDSH where SDSHno = 1;