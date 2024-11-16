use sqlTestTask;

--Вывести кол-во банковских карточек для каждого соц статуса
--(2 реализации, GROUP BY и подзапросом)

SELECT S.Id as Status_Id,
	S."Name" as Status_Name, 
	COUNT(C.Id) as "Cards Count"
FROM Cards C
	JOIN Accounts A ON A.Id = C.Account_Id
	JOIN Clients Cl ON Cl.Id = A.Client_Id
	RIGHT JOIN Statuses S ON S.Id = Cl.Status_Id
GROUP BY S.Id, S."Name"