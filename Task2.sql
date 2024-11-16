use sqlTestTask;

--Получить список карточек с указанием имени владельца, баланса и названия банка

SELECT C.Id AS Card_Id, Cl."Name", Cl.Surname, C.Balance, B."Name" 
FROM Cards C
	JOIN Accounts A ON A.Id=C.Account_Id
	JOIN Clients Cl ON Cl.Id=A.Client_Id
	JOIN Banks B ON B.Id=A.Bank_Id