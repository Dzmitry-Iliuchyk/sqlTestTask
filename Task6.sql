USE sqlTestTask;
--Получить список доступных средств для каждого клиента.
--То есть если у клиента на банковском аккаунте 60 рублей,
--и у него 2 карточки по 15 рублей на каждой,
--то у него доступно 30 рублей для перевода на любую из карт

SELECT  Cl."Name", Cl.Surname, 
	COALESCE(SUM(A.Balance),0) - COALESCE(SUM(C.Balance),0) as Available_Money
FROM Clients Cl
	LEFT JOIN Accounts A ON A.Client_Id=Cl.Id
	LEFT JOIN Cards C ON C.Account_Id=A.Id
GROUP BY Cl.Id, Cl."Name", Cl.Surname