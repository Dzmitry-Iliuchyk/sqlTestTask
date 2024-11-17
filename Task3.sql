use sqlTestTask;

--Показать список банковских аккаунтов у которых баланс не 
--совпадает с суммой баланса по карточкам. В отдельной колонке вывести разницу

SELECT A.Id as Account_Id, 
	A.Balance as Account_Balance,
	COALESCE(SUM(C.Balance),0) as Card_Balance,
	A.Balance - COALESCE(SUM(C.Balance),0) as Differce
FROM Accounts A
	LEFT JOIN Cards C ON C.Account_Id=A.Id
GROUP BY A.Id, A.Balance
HAVING COALESCE(SUM(C.Balance),0) != A.Balance