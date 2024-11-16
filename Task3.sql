use sqlTestTask;

--Показать список банковских аккаунтов у которых баланс не 
--совпадает с суммой баланса по карточкам. В отдельной колонке вывести разницу

SELECT A.Id as Account_Id, 
	A.Balance as Account_Balance,
	SUM(C.Balance) as Card_Balance,
	A.Balance - SUM(C.Balance) as Differce
FROM Accounts A
	JOIN Cards C ON C.Account_Id=A.Id
GROUP BY A.Id, A.Balance
HAVING SUM(C.Balance) != A.Balance