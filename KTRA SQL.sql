
CREATE DATABASE AZBank;
GO

USE AZBank;
GO

CREATE TABLE Customer (
    CustomerId INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(50),
	City VARCHAR(50),
    Country VARCHAR(50) ,
    Phone VARCHAR(15) ,
    Email VARCHAR(50) 
);

CREATE TABLE CustomerAccount (
    AccountNumber char(9) INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT,
    Balance money ,
	MinAccount money NOT NULL,
    FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId)
);

CREATE TABLE CustomerTransaction (
    TransactionId INT PRIMARY KEY IDENTITY(1,1),
    AccountNumber char(9) NOT NULL,
    TransactionDate DATETIME NOT NULL,
    Amount Money NOT NULL,
    DepositorWithdraw BIT NOT NULL,
    FOREIGN KEY (AccountNumber) REFERENCES CustomerAccount (AccountNumber)
);

--INSERTING RECORDS--
INSERT INTO Customer (Name, Country, Phone, Email)
VALUES 
('John Doe', 'Hanoi', '1234567890', 'johndoe@gmail.com'),
('Jane Doe', 'Hanoi', '0987654321', 'janedoe@gmail.com'),
('Jim Smith', 'USA', '+1 123 456 789', 'jimsmith@email.com');

INSERT INTO CustomerAccount (CustomerId, Balance)
VALUES 
(1, 100000),
(2, 200000),
(3, 300000);

INSERT INTO CustomerTransaction (AccountNumber, TransactionDate, Amount, DepositorWithdraw)
VALUES 
(1, '2022-01-01', 50000, 'Deposit'),
(2, '2022-02-01', 100000, 'Withdraw'),
(3, '2022-03-01', 200000, 'Deposit');

--Query to get customers living in Ha noi:

SELECT *
FROM Customer
WHERE Country = 'Hanoi';

--Query to get account information--
SELECT c.Name, c.Phone, c.Email, ca.AccountNumber, ca.Balance
FROM Customer c
JOIN CustomerAccount ca ON c.CustomerId = ca.CustomerId;


--creating CHECK constraint--
ALTER TABLE CustomerTransaction
ADD CONSTRAINT CK_Amount 
CHECK (Amount > 0 AND Amount <= 1000000);
--7--
CREATE NONCLUSTERED INDEX IX_Customer_Name
ON Customer (Name);

--8--
CREATE VIEW vCustomerTransactions
AS
SELECT c.Name, ca.AccountNumber, ct.TransactionDate, ct.Amount, ct.DepositorWithdraw
FROM Customer c
JOIN CustomerAccount
--9--
CREATE PROCEDURE spAddCustomer (@CustomerId INT, @CustomerName VARCHAR(50), @Country VARCHAR(50), @Phone VARCHAR(50), @Email VARCHAR(50))
AS
BEGIN
    INSERT INTO Customer (CustomerId, Name, Country, Phone, Email)
    VALUES (@CustomerId, @CustomerName, @Country, @Phone, @Email)
END

EXEC spAddCustomer 1, 'John Doe', 'Hanoi', '123 456 789', 'johndoe@email.com'
EXEC spAddCustomer 2, 'Jane Doe', 'Hanoi', '0987 654 321', 'janedoe@email.com'
EXEC spAddCustomer 3, 'Jim Smith', 'USA', '+1 123 456 789', 'jimsmith@email.com'



--10--
CREATE PROCEDURE spGetTransactions (@AccountNumber INT, @FromDate DATE, @ToDate DATE)
AS
BEGIN
    SELECT Customer.Name, CustomerAccount.AccountNumber, CustomerTransaction.TransactionDate, CustomerTransaction.Amount, CustomerTransaction.DepositorWithdraw
    FROM Customer
    INNER JOIN CustomerAccount ON Customer.CustomerId = CustomerAccount.CustomerId
    INNER JOIN CustomerTransaction ON CustomerAccount.AccountNumber = CustomerTransaction.AccountNumber
    WHERE CustomerAccount.AccountNumber = @AccountNumber
      AND CustomerTransaction.TransactionDate BETWEEN @FromDate AND @ToDate
END