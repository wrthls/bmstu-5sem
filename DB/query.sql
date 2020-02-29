use VinylShop
go

declare @temp nvarchar(4000)
set @temp =
(SELECT Dno AS [FK.Dno], Sno AS [FK.Sno], SHno AS [FK.SHno],
Qty AS Qty

FROM SDSH
FOR JSON PATH, ROOT('Shop'))

select @temp

declare @temp2 nvarchar(4000)
set @temp2 = (
SELECT * FROM OPENROWSET(BULK N'/structure.json', SINGLE_CLOB) AS Contents
)

SELECT *
FROM OPENJSON(@temp2, N'$.GroupedByGenre')
WITH (
    disk1t      VARCHAR(10)    N'$.disk1.type',
    disk1i      VARCHAR(10)    N'$.disk1.id',
    disk1n      VARCHAR(10)    N'$.disk1.name',
    disk1g      VARCHAR(10)    N'$.disk1.genre',

    disk2t      VARCHAR(10)    N'$.disk2.type',
    disk2i      VARCHAR(10)    N'$.disk2.id',
    disk2n      VARCHAR(10)    N'$.disk2.name',
    disk2g      VARCHAR(10)    N'$.disk2.genre',

    disk3t      VARCHAR(10)    N'$.disk3.type',
    disk3i      VARCHAR(10)    N'$.disk3.id',
    disk3n      VARCHAR(10)    N'$.disk3.name',
    disk3g      VARCHAR(10)    N'$.disk3.genre'
)
