use sqlTestTask;

--Вывести кол-во банковских карточек для каждого соц статуса
--(2 реализации, GROUP BY и подзапросом)

--Вариант 1
SELECT S.Id as Status_Id,
	S."Name" as Status_Name, 
	COUNT(C.Id) as "Cards Count"
FROM Cards C
	JOIN Accounts A ON A.Id = C.Account_Id
	JOIN Clients Cl ON Cl.Id = A.Client_Id
	RIGHT JOIN Statuses S ON S.Id = Cl.Status_Id
GROUP BY S.Id, S."Name"

--Вариант 2
SELECT 
    S.Id AS Status_Id,
    S."Name" AS Status_Name,
    COALESCE(COUNT_Cards."Cards Count", 0) AS "Cards Count"
FROM 
    Statuses S
LEFT JOIN (
    SELECT DISTINCT
        Cl.Status_Id,
        COUNT(C.Id) OVER (PARTITION BY Cl.Status_Id) AS "Cards Count"
    FROM 
        Cards C
    JOIN 
        Accounts A ON A.Id = C.Account_Id
    JOIN 
        Clients Cl ON Cl.Id = A.Client_Id
) COUNT_Cards ON S.Id = COUNT_Cards.Status_Id
