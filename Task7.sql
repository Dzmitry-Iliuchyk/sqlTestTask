USE sqlTestTask;
GO

-- Написать процедуру которая будет переводить определённую сумму со счёта на карту этого аккаунта.  
--При этом будем считать что деньги на счёту все равно останутся, просто сумма средств на карте увеличится.
--Например, у меня есть аккаунт на котором 1000 рублей и две карты по 300 рублей на каждой. 
--Я могу перевести 200 рублей на одну из карт, при этом баланс аккаунта останется 1000 рублей, 
--а на картах будут суммы 300 и 500 рублей соответственно.
--После этого я уже не смогу перевести 400 рублей с аккаунта ни на одну из карт,
--так как останется всего 200 свободных рублей (1000-300-500). 
--Переводить БЕЗОПАСНО. То есть использовать транзакцию


CREATE PROCEDURE TransferFromAccountToCard
(
	@Card_Id INTEGER,
	@AmountOfMoney Decimal(8,2)
)
AS
BEGIN
	BEGIN TRANSACTION;
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		
	IF NOT EXISTS ( SELECT 1 
					FROM Cards  
					WHERE Cards.Id=@Card_Id) 
		BEGIN 
			RAISERROR ('Invalid card ID.', 16, 4 ); 
			ROLLBACK TRANSACTION;
			RETURN; 
		END;

	IF @AmountOfMoney < 0			
		BEGIN 
			RAISERROR ('The amount of money cannot be less than 0', 16, 5);
			ROLLBACK TRANSACTION;
			RETURN;
		END

	DECLARE @Account_Id INTEGER;
	SET @Account_Id = ( SELECT C.Account_Id 
						FROM Cards C 
						WHERE C.Id = @Card_Id);
		
	IF @AmountOfMoney > (SELECT A.Balance - SUM(C.Balance) 
						 FROM Accounts A 
							 JOIN Cards C ON C.Account_Id = A.Id
						 WHERE A.Id = @Account_Id
						 GROUP BY A.Id, A.Balance)
		BEGIN 
			RAISERROR ('There is not enough money in the account', 16, 6);
			ROLLBACK TRANSACTION;
			RETURN;
		END

	UPDATE Cards
	SET Balance = Balance + @AmountOfMoney
	WHERE Cards.Id = @Card_Id

	COMMIT TRANSACTION;
END

GO

--Код теста
DECLARE @Card_Id INTEGER,
	@AmountOfMoney DECIMAL(8,2)

SET	@Card_Id = 20;
SET	@AmountOfMoney = 10.01;

SELECT A.Id AS Account_Id,
	A.Balance AS Account_Balance,
	C.Id AS Card_Id,
	C.Balance AS Card_Balance,
	'Before procedure' 
FROM Accounts A 
	JOIN Cards C ON C.Account_Id = A.Id
WHERE C.Id=@Card_Id;

EXEC dbo.TransferFromAccountToCard @Card_Id, @AmountOfMoney

SELECT A.Id AS Account_Id,
	A.Balance AS Account_Balance,	
	C.Id AS Card_Id, 
	C.Balance AS Card_Balance,
	'After procedure'  
FROM Accounts A 
	JOIN Cards C ON C.Account_Id = A.Id
WHERE C.Id=@Card_Id;