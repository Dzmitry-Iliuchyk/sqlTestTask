USE sqlTestTask;
GO
--Написать триггер на таблицы Account/Cards чтобы нельзя было занести значения в поле баланс если это противоречит условиям 
--(то есть нельзя изменить значение в Account на меньшее, чем сумма балансов по всем карточкам.
--И соответственно нельзя изменить баланс карты если в итоге сумма на картах будет больше чем баланс аккаунта)

CREATE TRIGGER Accounts_INSERT_UPDATE
ON Accounts
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT 1 FROM inserted Ins
					JOIN Cards C ON C.Account_Id = Ins.Id
				GROUP BY Ins.Id, Ins.Balance
				HAVING Ins.Balance < SUM(C.Balance))
	BEGIN
		RAISERROR ('The account balance must be greater than the total balance on the cards', 16, 8);
		ROLLBACK TRANSACTION;
		RETURN;
	END;
END

GO

CREATE TRIGGER Cards_INSERT_UPDATE
ON Cards
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS ( SELECT 1
				FROM inserted ins 
					JOIN Accounts A ON ins.Account_Id = A.Id 
				WHERE ins.Balance > A.Balance 
					OR ( SELECT SUM(c.Balance) 
						 FROM Cards C 
						 WHERE C.Account_Id = ins.Account_Id)
					+ ins.Balance  
						- COALESCE((SELECT Balance
								  FROM Cards 
								  WHERE Id = ins.Id), 0)
					> A.Balance )
	BEGIN
		RAISERROR ('The total balance in the cards must be less than the account balance', 16, 9);
		ROLLBACK TRANSACTION;
		RETURN;
	END;
END

GO
--Тест на неверные данные
DECLARE @Card_Id INTEGER,
	@Account_Id INTEGER

SET	@Card_Id = 20;
SET	@Account_Id = 9;

SELECT A.Id AS Account_Id,
	A.Balance AS Account_Balance,
	SUM(C.Balance) AS Card_Balance,
	'Before update' 
FROM Accounts A 
	JOIN Cards C ON C.Account_Id = A.Id
WHERE A.Id = @Account_Id
GROUP BY A.Id, A.Balance;

UPDATE Cards 
SET Balance = 99999.00
WHERE Id = @Card_Id;

UPDATE Accounts 
SET Balance = 0.00
WHERE Id = @Account_Id;

SELECT A.Id AS Account_Id,
	A.Balance AS Account_Balance,
	SUM(C.Balance) AS Card_Balance,
	'After update' 
FROM Accounts A 
	JOIN Cards C ON C.Account_Id = A.Id
WHERE A.Id = @Account_Id
GROUP BY A.Id, A.Balance;

GO
--Тест на верные данные
DECLARE @Card_Id INTEGER,
	@Account_Id INTEGER

SET	@Card_Id = 20;
SET	@Account_Id = 9;

SELECT A.Id AS Account_Id,
	A.Balance AS Account_Balance,
	SUM(C.Balance) AS Card_Balance,
	'Before update' 
FROM Accounts A 
	JOIN Cards C ON C.Account_Id = A.Id
WHERE A.Id = @Account_Id
GROUP BY A.Id, A.Balance;

UPDATE Cards 
SET Balance = 12.00
WHERE Id = @Card_Id;

UPDATE Accounts 
SET Balance = 7777.00
WHERE Id = @Account_Id;

SELECT A.Id AS Account_Id,
	A.Balance AS Account_Balance,
	SUM(C.Balance) AS Card_Balance,
	'After update' 
FROM Accounts A 
	JOIN Cards C ON C.Account_Id = A.Id
WHERE A.Id = @Account_Id
GROUP BY A.Id, A.Balance;