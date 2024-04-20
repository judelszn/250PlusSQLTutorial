-- Business scenario Q191 - Stock Group Assignment Audit
USE WideWorldImporters;

SELECT SG.StockGroupName
	, SI.StockItemName
	, AP.FullName AS AssignedBy
	, ISG.LastEditedWhen AS AssignmentDate
FROM Warehouse.StockItemStockGroups ISG
INNER JOIN Warehouse.StockGroups SG
ON ISG.StockGroupID = SG.StockGroupID
INNER JOIN Warehouse.StockItems SI
ON ISG.StockItemID = SI.StockItemID
INNER JOIN Application.People AP
ON ISG.LastEditedBy = AP.PersonID
ORDER BY ISG.LastEditedWhen
;


-- Business scenario Q192 - Demand Forecasting
USE AdventureWorks2022;
WITH DemandForecast AS (
	SELECT PP.ProductID
		, PP.Name AS ProductName
		, YEAR(SOH.OrderDate) AS SalesYear
		, MONTH(SOH.OrderDate) AS SalesMonth
		, SUM(SOD.OrderQty) AS TotalOrderQuantity
	FROM Production.Product PP
	LEFT JOIN Sales.SalesOrderDetail SOD
	ON PP.ProductID = SOD.ProductID
	LEFT JOIN Sales.SalesOrderHeader SOH
	ON SOD.SalesOrderID = SOH.SalesOrderID
	WHERE SOH.OrderDate >= DATEADD(YEAR, -12 ,GETDATE())
	GROUP BY PP.ProductID, PP.Name, YEAR(SOH.OrderDate), MONTH(SOH.OrderDate)
)
SELECT ProductID
	, SalesYear
	, SalesMonth
	, SUM(TotalOrderQuantity) AS DemandForecast
FROM DemandForecast
GROUP BY ProductID, ProductName, SalesYear, SalesMonth
ORDER BY ProductID, SalesYear, SalesMonth
;


-- Business scenario Q193 - Product Line Expansion
WITH ProductExpansionAnalysis AS (
	SELECT P.ProductID
		, P.Name AS ProductName
		, AVG(P.StandardCost) AS AverageStandardCost
		, AVG(P.ListPrice) AS AverageListPrice
		, SUM(SOD.OrderQty) AS TotalUnitsSold
		, SUM(SOD.LineTotal) AS TotalRevenue
	FROM Production.Product P
	LEFT JOIN Sales.SalesOrderDetail SOD
	ON P.ProductID = SOD.ProductID
	GROUP BY P.ProductID, P.Name
)
SELECT ProductID
	, ProductName
	, AverageStandardCost
	, AverageListPrice
	, TotalUnitsSold
	, TotalRevenue
	, (TotalRevenue - (AverageStandardCost * TotalUnitsSold)) AS GrossProfit
	, (TotalRevenue - (AverageStandardCost * TotalUnitsSold))*100 / TotalRevenue AS GrossMarginPercentage
FROM ProductExpansionAnalysis
ORDER BY GrossProfit DESC
;


-- Business scenario Q194 - Product Return Analysis
WITH ProductReturnAnalysis AS (
	SELECT P.ProductID
		, P.Name AS ProductName
		, COUNT(SOD.SalesOrderID) AS TotalOrders
		, SUM(SOD.OrderQty) AS TotalUnitsSold
		, COUNT(DISTINCT PR.ProductReviewID) AS TotalReview
		, SUM(CASE WHEN SOH.OrderDate >= '2014-01-01' THEN 1 ELSE 0 END) AS RecentOrders
	FROM Production.Product P
	LEFT JOIN Sales.SalesOrderDetail SOD
	ON P.ProductID = SOD.ProductID
	LEFT JOIN Sales.SalesOrderHeader SOH
	ON SOD.SalesOrderID = SOH.SalesOrderID
	LEFT JOIN Production.ProductReview PR
	ON P.ProductID = PR.ProductID
	WHERE SOH.OrderDate >= '2009-01-01'
	GROUP BY P.ProductID, P.Name
)
SELECT ProductID
	, ProductName
	, TotalOrders
	, TotalUnitsSold
	, TotalReview
	, RecentOrders
	, CASE 
		WHEN TotalUnitsSold = 0 THEN 0
		ELSE (TotalOrders - RecentOrders) * 100 / TotalUnitsSold
	  END AS ReturnRatePercentage
FROM ProductReturnAnalysis
ORDER BY ReturnRatePercentage DESC
;


-- Business scenario Q195 - E-commerce Conversion Rate Optimisation
WITH WebsiteConversion AS (
	SELECT YEAR(OH.OrderDate) AS SalesYear
		, COUNT(DISTINCT OH.CustomerID) AS TotalCustomers
		, COUNT(SO.SalesOrderID) AS TotalOrders
		, 100 * COUNT(SO.SalesOrderID) / COUNT(DISTINCT OH.CustomerID) AS ConversionRate
	FROM Sales.SalesOrderHeader OH
	LEFT JOIN Sales.SalesOrderHeader SO
	ON OH.CustomerID = SO.CustomerID
	WHERE YEAR(OH.OrderDate) >= YEAR(GETDATE()) - 20
	GROUP BY YEAR(OH.OrderDate)
)
SELECT SalesYear
	, TotalCustomers
	, TotalOrders
	, ConversionRate
FROM WebsiteConversion
ORDER BY SalesYear
;
