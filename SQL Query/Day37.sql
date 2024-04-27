-- Business scenario Q231 - Yearly Transaction Summary
DECLARE @TargetYear INT = 2023;
USE [Finance and Banking];
SELECT C.CustomerID
	, C.FirstName
	, C.LastName
	, C.Email
	, C.PhoneNumber
	, SUM(CASE WHEN YEAR(T.TransactionDate) = @TargetYear THEN 1 ELSE 0 END) AS TransactionCount
	, SUM(CASE WHEN YEAR(T.TransactionDate) = @TargetYear THEN T.Amount ELSE 0 END) AS TotalAmount
FROM Finance.UniqueCustomers C
LEFT JOIN Finance.UniqueAccounts A
ON C.CustomerID = A.CustomerID
LEFT JOIN Finance.UniqueTransactions T
ON A.AccountID = T.AccountID
WHERE YEAR(T.TransactionDate) = @TargetYear
GROUP BY C.CustomerID, C.FirstName, C.LastName, C.Email, C.PhoneNumber
ORDER BY C.CustomerID
;


-- Business scenario Q232 - Account Closure Analysis
SELECT A.AccountID
	, C.CustomerID
	, C.FirstName
	, C.LastName
	, C.Email
	, C.PhoneNumber
	, A.AccountType
	, A.Balance
	, MAX(T.TransactionDate) AS LastTransactionDate
	, CASE
		WHEN MAX(T.TransactionDate) IS NULL THEN 'No Transactions'
		WHEN MAX(T.TransactionDate) IS NOT NULL AND A.Balance = 0 THEN 'Zero Balance'
		ELSE 'Other Reasons'
	  END AS ClosureReason		
FROM Finance.UniqueCustomers C
INNER JOIN Finance.UniqueAccounts A
ON C.CustomerID = A.CustomerID
LEFT JOIN Finance.UniqueTransactions T
ON A.AccountID =T.AccountID
GROUP BY A.AccountID, C.CustomerID, C.FirstName, C.LastName, C.Email, C.PhoneNumber, A.AccountType, A.Balance
HAVING MAX(T.TransactionDate) IS NOT NULL
ORDER BY A.AccountID
;


-- Business scenario Q233 - Yearly Transaction Trend Analysis
SELECT  YEAR(T.TransactionDate) AS TransactionYear
	, CASE
		WHEN A.AccountType = 'savings' THEN 'Savings'
		WHEN A.AccountType = 'checking' THEN 'Checking'
	  END AS AccountType
	, COUNT(T.TransactionID) AS TransactionCount
FROM Finance.UniqueTransactions T
INNER JOIN Finance.UniqueAccounts A
ON T.AccountID = A.AccountID
GROUP BY YEAR(T.TransactionDate), A.AccountType
ORDER BY YEAR(T.TransactionDate), A.AccountType
;


-- Business scenario Q234 - Customer Transaction Analysis
SELECT C.CustomerID
	, C.FirstName
	, C.LastName
	, C.Email
	, C.PhoneNumber
	, A.AccountType
	, A.Balance
	, COUNT(CASE WHEN T.TransactionType = 'Deposit' THEN 1 ELSE 0 END) AS DepositCount
	, COUNT(CASE WHEN T.TransactionType = 'Withdrawal' THEN 1 ELSE 0 END) AS WithdrawalCount
FROM Finance.UniqueCustomers C
INNER JOIN Finance.UniqueAccounts A
ON C.CustomerID = A.CustomerID
LEFT JOIN Finance.UniqueTransactions T
ON A.AccountID = T.AccountID
GROUP BY A.AccountID, C.CustomerID, C.FirstName, C.LastName, C.Email,
C.PhoneNumber, A.AccountType, A.Balance
ORDER BY C.CustomerID
;


-- Business scenario Q235 - Customer Transaction Classification
SELECT C.CustomerID
	, C.FirstName
	, C.LastName
	, C.Email
	, C.PhoneNumber
	, CASE 
		WHEN TransactionCount >= 10 AND AverageBalance >= 5000 THEN 'Active'
		WHEN TransactionCount >= 5 AND AverageBalance >= 1000 THEN 'Occasional'
		ELSE 'Inactive'
	  END AS CustomerSegment
FROM Finance.UniqueCustomers C
LEFT JOIN (SELECT A.CustomerID
				, COUNT(t.TransactionID) AS TransactionCount
				, AVG(A.Balance) AS AverageBalance
			FROM Finance.UniqueAccounts A
			LEFT JOIN Finance.UniqueTransactions T
			ON A.AccountID = T.AccountID
			GROUP BY A.CustomerID
			) AS CustomerSummary
ON C.CustomerID = CustomerSummary.CustomerID
ORDER BY C.CustomerID
;