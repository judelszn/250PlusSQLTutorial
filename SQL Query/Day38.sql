-- Business scenario Q236 - Transaction Anomaly Detection
USE [Finance and Banking];
SELECT T.TransactionID
	, C.CustomerID
	, C.FirstName
	, C.LastName
	, T.TransactionDate
	, T.Amount
	, A.AccountType
	, A.Balance
	, CASE
		WHEN ABS(T.Amount - AVG(TT.Amount)) > 2 * STDEV(TT.Amount) THEN 'Anomaly Detected'
		ELSE 'Normal'
	  END AS TransactionStatus
FROM Finance.UniqueTransactions T
INNER JOIN Finance.UniqueAccounts A
ON T.AccountID = A.AccountID
INNER JOIN Finance.UniqueCustomers C
ON A.CustomerID = C.CustomerID
LEFT JOIN Finance.UniqueTransactions TT
ON A.AccountID <> TT.AccountID
GROUP BY T.TransactionID, C.CustomerID, C.FirstName, C.LastName, T.TransactionDate, T.Amount
	, T.TransactionType, A.AccountType, A.Balance
ORDER BY T.TransactionID
;


-- Business scenario Q237 - Branch Transaction Comparison
DECLARE @StartDate DATE = '2022-01-01';
DECLARE @EndDate DATE = '2023-01-01';
SELECT B.BranchID
	, B.BranchName
	, B.Location
	, COUNT(T.TransactionID) AS TransactionCount
FROM Finance.UniqueBranches B
LEFT JOIN Finance.UniqueAccountBranches AB
ON B.BranchID = AB.BranchID
JOIN Finance.UniqueTransactions T
ON AB.AccountID = T.AccountID
WHERE T.TransactionDate BETWEEN @StartDate AND @EndDate
GROUP BY B.BranchID, B.BranchName, B.Location
ORDER BY COUNT(T.TransactionID) DESC
SELECT B.BranchID
	, B.BranchName
	, B.Location
	, COUNT(Ab.AccountID) AS TransactionCount
FROM Finance.UniqueBranches B
LEFT JOIN Finance.UniqueAccountBranches AB
ON B.BranchID = AB.BranchID
GROUP BY B.BranchID, B.BranchName, B.Location
ORDER BY COUNT(AB.AccountID) DESC
;


-- Business scenario Q238 - Customer Branch Preference
