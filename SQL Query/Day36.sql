-- Business scenario Q226 - Average Order Line Amount by Package Type
USE WideWorldImporters;
WITH OrderLineDetails AS (
	SELECT PT.PackageTypeName
		, OL.UnitPrice * OL.Quantity AS LineAmount
	FROM Warehouse.PackageTypes PT
	JOIN Warehouse.StockItems SI
	ON PT.PackageTypeID = SI.UnitPackageID
	LEFT JOIN Sales.OrderLines OL
	ON SI.StockItemID = OL.StockItemID
)
SELECT LD.PackageTypeName
	, AVG(LD.LineAmount) AS AverageOrderLineAmount
FROM OrderLineDetails LD
GROUP BY LD.PackageTypeName
ORDER BY AVG(LD.LineAmount) DESC
;


-- Business scenario Q227 - Top Stock Items Analysis
WITH RankedStockItems AS (
	SELECT ISG.StockGroupID
		, SI.StockItemID
		, SI.StockItemName
		, SUM(OL.Quantity) AS TotalQuantitySold
		, ROW_NUMBER() OVER(PARTITION BY ISG.StockGroupID ORDER BY SUM(OL.Quantity) DESC) AS ItemRank
	FROM Warehouse.StockItemStockGroups ISG
	INNER JOIN Warehouse.StockItems SI
	ON ISG.StockItemID = SI.StockItemID
	LEFT JOIN Sales.OrderLines OL
	ON SI.StockItemID = OL.StockItemID
	WHERE OL.OrderID IS NOT NULL
	GROUP BY ISG.StockGroupID, SI.StockItemID, SI.StockItemName
)
SELECT RI.StockGroupID
	, SG.StockGroupName
	, RI.StockItemID
	, RI.StockItemName
	, RI.TotalQuantitySold
	, AVG(RI.TotalQuantitySold) OVER(PARTITION BY RI.StockGroupID) AS AverageQuantitySold
	, SUM(RI.TotalQuantitySold) OVER(PARTITION BY RI.StockGroupID) AS TotalQuantitySold
FROM RankedStockItems RI
INNER JOIN Warehouse.StockGroups SG
ON RI.StockGroupID = SG.StockGroupID
WHERE RI.ItemRank = 1
;


-- Business scenario Q228. - Stock Group Analysis with Ranking and Growth
WITH RankedStockGroups AS (
	SELECT SG.StockGroupID
		, SG.StockGroupName
		, SUM(OL.Quantity) AS TotalQuantitySold
		, RANK() OVER(ORDER BY SUM(OL.Quantity) DESC) AS RankByQuantitySold
		, LAG(SUM(OL.Quantity)) OVER(ORDER BY SG.StockGroupID) AS PreviewQuantitySold
		, SUM(SUM(OL.Quantity)) OVER(ORDER BY SG.StockGroupID) AS CumulativeQuantitySold
		, LEAD(SUM(OL.Quantity)) OVER(ORDER BY SG.StockGroupID) AS NextQuantitySold
	FROM Warehouse.StockGroups SG
	LEFT JOIN Warehouse.StockItemStockGroups ISG
	ON SG.StockGroupID = ISG.StockGroupID
	LEFT JOIN Warehouse.StockItems SI
	ON ISG.StockItemID = SI.StockItemID
	LEFT JOIN Sales.OrderLines OL
	ON SI.StockItemID = OL.StockItemID
	GROUP BY SG.StockGroupID, SG.StockGroupName
)
SELECT RG.StockGroupID
	, RG.StockGroupName
	, RG.TotalQuantitySold
	, RG.RankByQuantitySold
	, CASE
		WHEN RG.PreviewQuantitySold IS NULL THEN NULL
		ELSE (RG.TotalQuantitySold - RG.PreviewQuantitySold) * 100 / RG.PreviewQuantitySold
	  END AS SalesGrowthRate
	, RG.CumulativeQuantitySold
	, RG.NextQuantitySold
FROM RankedStockGroups RG
;


-- Business scenario Q229 - Loan Application and Approval
USE [Finance and Banking];
WITH LoanApplications AS (
	SELECT C.CustomerID
		, C.FirstName
		, C.LastName
		, A.AccountID
		, A.AccountType
		, A.Balance
		, CASE
			WHEN A.Balance >= 5000 THEN 'Eligible'
			ELSE 'Not Eligible'
		  END AS LoanEligibility	
	FROM Finance.UniqueCustomers C
	INNER JOIN Finance.UniqueAccounts A
	ON C.CustomerID = A.CustomerID
	WHERE A.AccountType = 'Savings'
)
SELECT LA.CustomerID
	, LA.FirstName
	, LA.LastName
	, LA.AccountID
	, LA.AccountType
	, LA.Balance
	, LA.LoanEligibility
	, CASE 
		WHEN LA.LoanEligibility = 'Eligible' THEN 'Approved'
		ELSE 'Rejected'
	  END AS LoanStatus	
FROM LoanApplications LA
;


-- Business scenario Q230 - Account Type Distribution Analysis
SELECT CASE
		WHEN A.AccountType = 'savings' THEN 'Savings'
		WHEN A.AccountType = 'checking' THEN 'Checking'
	   END AS AccountType
	, COUNT(DISTINCT C.CustomerID) AS NumberOfCustomers
	, COUNT(DISTINCT C.CustomerID) * 100.0 / (SELECT COUNT(DISTINCT C.CustomerID) 
	   FROM Finance.UniqueCustomers) AS AccountPercentage
FROM Finance.UniqueAccounts A
INNER JOIN Finance.UniqueCustomers C
ON A.CustomerID = C.CustomerID
GROUP BY A.AccountType