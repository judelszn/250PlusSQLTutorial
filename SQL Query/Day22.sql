-- Business scenario Q156 - Customer Segmentation for Targeted Marketing
SELECT UC.CustomerID
	, CONCAT(UC.FirstName, ' ', UC.LastName) AS FullName
	, AVG(UA.Balance) AS AverageBalance
	, CASE
		WHEN AVG(UA.Balance) >= 5000 THEN 'High-Value'
		WHEN AVG(UA.Balance) >= 1000 AND AVG(UA.Balance) < 500 THEN 'Medium-Value'
		ELSE 'Low-Value'
	  END AS CustomerSegment	
FROM Finance.UniqueCustomers UC
INNER JOIN Finance.UniqueAccounts UA
ON UC.CustomerID = UA.CustomerID
GROUP BY UC.CustomerID, UC.FirstName, UC.LastName
;


-- Business scenario Q157 - Account Type Analysis
SELECT UA.AccountType
	, COUNT(DISTINCT UC.CustomerID) AS CustomersCount
FROM Finance.UniqueAccounts UA
INNER JOIN Finance.UniqueCustomers UC
ON UA.CustomerID = UC.CustomerID
GROUP BY UA.AccountType
ORDER BY UA.AccountType
;

SELECT UA.AccountType
	, ROUND(AVG(UA.Balance),2) AS AverageBalance
FROM Finance.UniqueAccounts UA
GROUP BY UA.AccountType
ORDER BY UA.AccountType
;


-- Business scenario Q158 - Overdraft Alert
SELECT UC.CustomerID
	, CONCAT(UC.FirstName, ' ', UC.LastName) AS FullName
	, UC.Email
	, UC.PhoneNumber
	, UA.AccountID
	, UA.AccountType
	, UA.Balance
FROM Finance.UniqueAccounts UA
INNER JOIN Finance.UniqueCustomers UC
ON UA.CustomerID = UC.CustomerID
WHERE UA.Balance < 1000
;
-- OR
DECLARE @Threshold DECIMAL(10,2) = 1000;
SELECT UC.CustomerID
	, CONCAT(UC.FirstName, ' ', UC.LastName) AS FullName
	, UC.Email
	, UC.PhoneNumber
	, UA.AccountID
	, UA.AccountType
	, UA.Balance
FROM Finance.UniqueAccounts UA
INNER JOIN Finance.UniqueCustomers UC
ON UA.CustomerID = UC.CustomerID
WHERE UA.Balance < @Threshold
;


-- Business scenario Q159 - Inactive Account Analysis
SELECT UC.CustomerID
	, CONCAT(UC.FirstName, ' ', UC.LastName) AS FullName
	, UA.AccountID
	, UA.AccountType
	, UA.Balance
FROM Finance.UniqueAccounts UA
INNER JOIN Finance.UniqueCustomers UC
ON UA.CustomerID = UC.CustomerID
LEFT JOIN Finance.UniqueTransactions UT
ON UA.AccountID = UT.AccountID
GROUP BY UC.CustomerID, UC.FirstName, UC.LastName, UA.AccountID, UA.AccountType, UA.Balance
HAVING MAX(UT.TransactionDate) IS NOT NULL 
OR MAX(UT.TransactionDate) < DATEADD(MONTH,-48,GETDATE())
;


-- Business scenario Q160 - Branch Transaction Analysis
DECLARE @StartDate DATE = '2022-01-01';
DECLARE @EndDate DATE = '2023-12-31';

SELECT B.BranchID
	, B.BranchName
	, B.Location
	, COUNT(T.TransactionID) AS TransactionCount
FROM Finance.UniqueBranches B
LEFT JOIN Finance.UniqueAccountBranches AB
ON B.BranchID = AB.BranchID
INNER JOIN Finance.UniqueTransactions T
ON AB.AccountID = T.AccountID
WHERE T.TransactionDate BETWEEN @StartDate AND @EndDate
GROUP BY B.BranchID, B.BranchName, B.Location
ORDER BY COUNT(T.TransactionID) DESC
;