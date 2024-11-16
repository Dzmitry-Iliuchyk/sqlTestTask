use sqlTestTask;

--Покажи мне список банков у которых есть филиалы в городе X (выбери один из городов)
SELECT B."Name" 
FROM Banks B
	JOIN Branches Br ON Br.Bank_Id=B.Id
	JOIN Cities C ON C.Id=Br.City_Id
WHERE C."Name"='City 2'
