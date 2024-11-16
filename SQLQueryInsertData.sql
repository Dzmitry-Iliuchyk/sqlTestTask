use sqlTestTask;

INSERT INTO Banks (Id, "Name") VALUES
(1, 'Bank 1'),
(2, 'Bank 2'),
(3, 'Bank 3'),
(4, 'Bank 4'),
(5, 'Bank 5');

INSERT INTO Statuses (Id, "Name") VALUES
(1, 'Common'),
(2, 'Disabled'),
(3, 'Foreigner'),
(4, 'Unreliable'),
(5, 'Banned');

INSERT INTO Cities (Id, "Name") VALUES
(1, 'City 1'),
(2, 'City 2'),
(3, 'City 3'),
(4, 'City 4'),
(5, 'City 5');

INSERT INTO Clients (Id, "Name", Surname, Status_Id) VALUES
(1, 'John', 'Doe', 5),
(2, 'Jane', 'Smith', 2),
(3, 'Alice', 'Johnson', 3),
(4, 'Bob', 'Brown', 1),
(5, 'Charlie', 'Davis', 4);

INSERT INTO Branches (Id, Bank_Id, City_Id, "Name") VALUES
(1, 1, 1, 'Branch 1 B1'),
(2, 2, 1,'Branch 1 B2'),
(3, 3, 1,'Branch 1 B3'),
(4, 2, 2,'Branch 2 B2'),
(5, 1, 3,'Branch 2 B1'),
(6, 3, 5, 'Branch 2 B3'),
(7, 4, 3, 'Branch 1 B4'),
(8, 4, 2, 'Branch 2 B4'),
(9, 5, 2, 'Branch 1 B5'),
(10, 4, 3, 'Branch 3 B4');

INSERT INTO Accounts (Id, Bank_Id, Client_Id, Balance) VALUES
(1, 1, 1, 1000.00),
(2, 2, 2, 2000.00),
(3, 3, 3, 3000.00),
(4, 4, 4, 4000.00),
(5, 5, 5, 5000.00);

INSERT INTO Cards (Id, Account_Id, Balance) VALUES
(1, 1, 500.00),
(2, 3, 1500.00),
(3, 4, 2042.00),
(4, 5, 250.00),
(5, 1, 500.00),
(6, 3, 150.00),
(7, 4, 200.00),
(8, 5, 250.00),
(9, 3, 150.00),
(10, 4, 200.00),
(11, 5, 2000.00);
