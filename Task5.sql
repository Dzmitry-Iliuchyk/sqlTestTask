USE sqlTestTask;
GO
--Написать stored procedure которая будет добавлять по 10$ на каждый банковский аккаунт для определенного соц статуса
--(У каждого клиента бывают разные соц. статусы. Например, пенсионер, инвалид и прочее).
--Входной параметр процедуры - Id социального статуса.
--Обработать исключительные ситуации (например, был введен неверные номер соц. статуса. Либо когда у этого статуса нет привязанных аккаунтов).

CREATE PROCEDURE Add10ToBalanceBySocialGroup
(
    @Status_Id INTEGER
)
AS
BEGIN

	IF NOT EXISTS (SELECT * 
					FROM Clients 
					WHERE Status_Id = @Status_Id) 
		BEGIN 
			RAISERROR ('Invalid social status ID.', 5, 1 ); 
			RETURN; 
		END;

	IF NOT EXISTS (SELECT * 
					FROM Accounts A 
						JOIN Clients Cl ON Cl.Id = A.Client_Id 
					WHERE Cl.Status_Id = @Status_Id)
		BEGIN 
			RAISERROR ('No accounts associated with the given social status ID.', 5, 2);
			RETURN;
		END

	UPDATE Accounts
	SET Balance = inn.Balance + 10
	FROM (SELECT A.Id, A.Balance 
		FROM Accounts A 
			JOIN Clients Cl ON Cl.Id = A.Client_Id 
		WHERE Cl.Status_Id = @Status_Id) as inn
	WHERE Accounts.Id = inn.Id
END
GO

DECLARE @Status_Id INT

SET @Status_Id = 2;

SELECT A.Id, A.Balance 
FROM Accounts A 
	JOIN Clients Cl ON Cl.Id = A.Client_Id 
--WHERE Cl.Status_Id=@Status_Id;

EXEC dbo.Add10ToBalanceBySocialGroup @Status_Id

SELECT A.Id, A.Balance 
FROM Accounts A 
	JOIN Clients Cl ON Cl.Id = A.Client_Id 
--WHERE Cl.Status_Id=@Status_Id;