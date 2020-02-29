--1)
SELECT Ename, 
    CASE
        WHEN Eid > 7  THEN 'MOST RESENT ADDED'
        WHEN Eid > 4 THEN 'RESENT ADDED'
        ELSE 'NOT RESENT'
    END AS 'AdditionStatus'
FROM RK2.dbo.Excursion;
GO

-- 2
UPDATE Excursion
SET Descript = 
(
    SELECT Descript
    FROM Stand
    WHERE [Sid] = 5
)
WHERE Eid = 5

--3
SELECT SubjectArea
FROM Stand
GROUP BY SubjectArea
HAVING SubjectArea IN
(
    Select SubjectArea
    FROM Stand
    WHERE Descript IS NOT NULL
)