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
SELECT C.CustomerID
	, C.FirstName
	, C.LastName
	, B.BranchName AS PreferredBranch
	, MAX(T.TransactionDate) AS LastTransactionDate
FROM Finance.UniqueCustomers C
LEFT JOIN Finance.UniqueAccounts A
ON C.CustomerID = A.CustomerID
LEFT JOIN Finance.UniqueAccountBranches AB
ON A.AccountID = AB.AccountID
LEFT JOIN Finance.UniqueBranches B
ON AB.BranchID = B.BranchID
LEFT JOIN Finance.UniqueTransactions T
ON A.AccountID = T.AccountID
GROUP BY C.CustomerID, C.FirstName, C.LastName, B.BranchName
HAVING MAX(T.TransactionDate) IS NOT NULL
ORDER BY C.CustomerID
;


-- Business scenario Q239 - Branch Profitability Analysis
SELECT B.BranchID
	, B.BranchName
	, B.Location
	, B.City
	, SUM(T.Amount) AS TransactionRevenue
	, SUM(CASE WHEN A.AccountType = 'savings' THEN 0.02 * A.Balance
			ELSE 0.01 * A.Balance END) AS AccountBalanceFees
	, SUM(T.Amount) + SUM(CASE WHEN A.AccountType = 'savings' THEN 0.02 * A.Balance
			ELSE 0.01 * A.Balance END) AS TotalProfit
FROM Finance.UniqueBranches B
LEFT JOIN Finance.UniqueAccountBranches AB
ON B.BranchID = AB.BranchID
LEFT JOIN Finance.UniqueAccounts A
ON AB.AccountID = A.AccountID
LEFT JOIN Finance.UniqueTransactions T
ON A.AccountID = T.AccountID
GROUP BY B.BranchID, B.BranchName, B.Location, B.City
;


-- Business scenario Q240 - The Prescription Adherence ProblemUSE HealthCare;SELECT PatientID	, FirstName	, LastName	, DateOfBirth	, Gender	, PhoneNumber	, EmailFROM Medical.PatientsWHERE (	EXISTS(		SELECT *		FROM Medical.Medications		WHERE PatientID = Patients.PatientID AND Dosage = '10 mg'		)	OR	EXISTS(		SELECT * 		FROM Medical.Appointments		WHERE PatientID = Appointments.PatientID AND Purpose = 'Critical care'	));