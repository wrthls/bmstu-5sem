/* 1. SELECT, использующая предикат сравнения. */
-- Магазины с рейтингм ниже 3
SELECT DISTINCT SHno, SHname, Rating 
FROM VinylShop.dbo.Shops
WHERE Rating < 3;


/* 2. Инструкция SELECT, использующая предикат BETWEEN.*/
-- Диски, весом от 250 до 255
SELECT DISTINCT Dno, Dalbum, Weight 
FROM VinylShop.dbo.Disks 
WHERE Weight BETWEEN 250 AND 255
ORDER BY (Weight);

/* 3. Инструкция SELECT, использующая предикат LIKE */
-- Cписок названий магазинов, начинающихся с 'ex'
SELECT DISTINCT SHname 
FROM VinylShop.dbo.Shops 
WHERE
SHname LIKE 'ex%';

/* 4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом. */
-- Получить список заказов, от поставщика №3, где жанр альбома - Classical
SELECT SDSHno, Sno, Dno 
FROM VinylShop.dbo.SDSH
WHERE Dno IN
(
    SELECT Dno FROM VinylShop.dbo.Disks
    WHERE Genre = 'Classical' 
) 
AND Sno = 3;

/* 5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом. */
-- Получить список альбомов, которые никто никогда не заказывал
SELECT Dno, Dalbum
FROM VinylShop.dbo.Disks
WHERE EXISTS
(
    SELECT dis.Dno
    FROM VinylShop.dbo.SDSH AS orders RIGHT OUTER JOIN VinylShop.dbo.Disks AS dis 
    ON orders.Dno = dis.Dno
    WHERE orders.Dno IS NULL
)

/* 6.Инструкция SELECT, использующая предикат сравнения с квантором */
-- Самая тяжелая пластинка
SELECT Qty 
FROM VinylShop.dbo.SDSH AS orders
WHERE Qty >= ALL
(SELECT Qty
FROM VinylShop.dbo.SDSH AS orders);

/* 7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов. */
-- 
SELECT AVG(Qty)
FROM VinylShop.dbo.SDSH

/* 8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов. */
 SELECT SDSHno, Qty
 FROM VinylShop.dbo.SDSH
 WHERE
 (Qty > 
    (SELECT AVG(Qty)
    FROM VinylShop.dbo.SDSH)
)

/* 9. Инструкция SELECT, использующая простое выражение CASE. */
SELECT SHname, 
    CASE Rating
        WHEN 10 THEN 'VERY GOOD'
        WHEN 9 THEN 'GOOD'
        ELSE 'BAD'
    END AS 'Description'
FROM VinylShop.dbo.Shops

/* 10. Инструкция SELECT, использующая поисковое выражение CASE. */
SELECT SHname, 
    CASE
        WHEN Rating > 7 THEN 'VERY GOOD'
        WHEN Rating > 4 THEN 'GOOD'
        ELSE 'BAD'
    END AS 'Description'
FROM VinylShop.dbo.Shops

/* 11. Создание новой временной локальной таблицы из 
результирующего набора данных инструкции SELECT. */
SELECT *
INTO #temp_sup
FROM Supliers;
GO

SELECT * FROM #temp_sup

/* 12. Инструкция SELECT, использующая вложенные коррелированные 
подзапросы в качестве производных таблиц в предложении FROM. */
SELECT * 
FROM Shops JOIN
(
    SELECT SDSHno, SHno, Qty 
    FROM
    SDSH
) AS a
ON Shops.SHno = a.SHno

/* 13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3. */
SELECT Sno 
FROM Supliers
WHERE City IN(
    SELECT City 
    FROM Shops
    WHERE SHno IN 
    (
        SELECT SHno
        FROM SDSH
        WHERE Dno IN
        (
            SELECT Dno 
            FROM Disks
            WHERE Weight BETWEEN 350 AND 360
        )
    )  
)

/* 14. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY,
 но без предложения HAVING. */
SELECT AVG(Weight), Genre
FROM Disks
GROUP BY Genre

/* 15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUPBY 
и предложения HAVING. */
SELECT AVG(Weight), Genre
FROM Disks
GROUP BY Genre
HAVING AVG(Weight) > 
(
    SELECT AVG(Weight) AS av_weight
    FROM Disks
)

/* 16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений. */
INSERT Shops(SHname, City, Rating) 
VALUES ('plastinochki', 'Moscow', 10)

/* 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса.*/
INSERT Shops(SHname, City, Rating) 
SELECT SHname, City, Rating
FROM Shops
WHERE SHno = 5

/* 18. Простая инструкция UPDATE */
UPDATE Shops
SET City = 'Mosocw'
WHERE SHno = 5

/* 19. Инструкция UPDATE со скалярным подзапросом в предложении SET. */
UPDATE Shops
SET City = 
(
    SELECT City
    FROM Shops
    WHERE SHno = 9
)
WHERE SHno = 5

/* 20. Простая инструкция DELETE. */
DELETE Shops
WHERE SHno > 900

/* 21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE. */
DELETE Shops
WHERE SHno IN
(
    SELECT SHno
    FROM SDSH 
    WHERE Dno > 900
)

/* 22. Инструкция SELECT, использующая простое обобщенное табличное выражение */
WITH CTE_1(SHno,SHname, City)
AS
(
    SELECT SHno,SHname, City
    FROM Shops
    WHERE SHno < 100
)
SELECT * FROM CTE_1

/* 23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение. */
CREATE TABLE dbo.Example
(
	My_id smallint NOT NULL,
	Parrent_id int NULL,
);
GO
INSERT dbo.Example VALUES(1,NULL);
GO
INSERT dbo.Example VALUES(2,1);
GO
INSERT dbo.Example VALUES(3,2);
GO
INSERT dbo.Example VALUES(4,2);
GO

WITH RecOTV(My_id, Parrent_id, Level)
AS
(
	SELECT e.My_id, e.Parrent_id, 0 AS Level
	FROM dbo.Example AS e
	WHERE Parrent_id IS NULL
	
	UNION ALL

	SELECT e.My_id, e.Parrent_id, Level + 1
	FROM dbo.Example AS e INNER JOIN RecOTV AS d ON e.Parrent_id = d.My_id
	)
Select My_id, Parrent_id, Level
FROM RecOTV;
GO

DROP TABLE dbo.Example;

/* 24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER() */
SELECT Dno, Dalbum, Genre, MIN(Weight) OVER(PARTITION BY Genre) AS min
FROM Disks

/* 25. Оконные фнкции для устранения дублей */

SELECT *
INTO #temp
FROM Shops;
GO

DELETE #temp
WHERE SHno IN
(
    SELECT SHno FROM
    (
        Select SHno, SHname, City, Rating, ROW_NUMBER() OVER(PARTITION BY SHname, City, Rating ORDER BY SHno) as 'Uniq'
        from Shops
    ) AS A
    WHERE A.Uniq > 1
)

