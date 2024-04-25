-- Business scenario Q221 - Evaluating Sales Quota Achievement
USE AdventureWorks2022;
SELECT SP.BusinessEntityID AS SalesPersonID
	, QH.QuotaDate
	, QH.SalesQuota
	, SUM(CASE WHEN OH.TotalDue >= QH.SalesQuota THEN 1 ELSE 0 END) AS QuoteMetCount
	, SUM(CASE WHEN OH.TotalDue < QH.SalesQuota THEN 1 ELSE 0 END) AS QuoteNotMetCount
FROM Sales.SalesPerson SP
INNER JOIN Sales.SalesPersonQuotaHistory QH
ON SP.BusinessEntityID = QH.BusinessEntityID
LEFT JOIN Sales.SalesOrderHeader OH
ON SP.BusinessEntityID = OH.SalesPersonID AND QH.QuotaDate = OH.OrderDate
GROUP BY SP.BusinessEntityID, QH.QuotaDate, QH.SalesQuota
ORDER BY SP.BusinessEntityID, QH.QuotaDate
;


-- Business scenario Q222 - Inventory Replenishment
WITH ProductSales AS (
	SELECT P.ProductID
		, P.Name AS ProductName
		, SUM(SI.Quantity) AS TotalSales
	FROM Production.Product P
	LEFT JOIN Sales.ShoppingCartItem SI
	ON P.ProductID = SI.ProductID
	GROUP BY P.ProductID, P.Name
),
	CurrentInventory AS (
	SELECT PP.ProductID
		, SUM(PP.Quantity) AS CurrentStock
	FROM Production.ProductInventory PP
	GROUP BY PP.ProductID
)	
SELECT PS.ProductID
	, PS.ProductName
	, PS.TotalSales
	, COALESCE(CI.CurrentStock, 0) AS CurrentStock
	, CASE
		WHEN CI.CurrentStock IS NULL THEN PS.TotalSales
		ELSE PS.TotalSales - CI.CurrentStock
	  END AS ReplenishQuantity
FROM ProductSales PS
LEFT JOIN CurrentInventory CI
ON PS.ProductID = CI.ProductID
;


-- Business scenario Q223 - Customer Shopping Behaviour Analysis
WITH ProductSales AS (
	SELECT P.ProductID
		, P.Name AS ProductName
		, PC.Name AS CategoryName
		, SUM(CI.Quantity) AS TotalSales
	FROM Production.Product P
	INNER JOIN Production.ProductSubcategory SC
	ON P.ProductSubcategoryID = SC.ProductSubcategoryID
	JOIN Production.ProductCategory PC
	ON SC.ProductCategoryID = PC.ProductCategoryID
	LEFT JOIN Sales.ShoppingCartItem CI
	ON P.ProductID = CI.ProductID
	GROUP BY P.ProductID, P.Name, PC.Name
)
SELECT *
FROM ProductSales PS
ORDER BY PS.TotalSales DESC
;


-- Business scenario Q224 - Supplier Evaluation for On-Time Deliveries
USE WideWorldImporters;
WITH SupplierDelivery AS (
	 SELECT S.SupplierID
		, S.SupplierName
		, COUNT(PO.PurchaseOrderID) AS TotalPurchaseOrders
		, SUM(CASE WHEN PO.ExpectedDeliveryDate >= ST.TransactionDate THEN 1 ELSE 0 END) 
		  AS OnTimeDelivery
	 FROM Purchasing.Suppliers S
	 LEFT JOIN Purchasing.PurchaseOrders PO
	 ON S.DeliveryMethodID = PO.DeliveryMethodID
	 JOIN Purchasing.SupplierTransactions ST
	 ON ST.SupplierID = PO.SupplierID
	 GROUP BY S.SupplierID, S.SupplierName
)
SELECT SD.SupplierName
	, SD.TotalPurchaseOrders
	, SD.OnTimeDelivery
	, CAST((SD.OnTimeDelivery * 100) / SD.TotalPurchaseOrders AS DECIMAL(10,2)) 
	  AS OnTimeDeliveryPercentage
FROM SupplierDelivery SD
ORDER BY OnTimeDeliveryPercentage DESC
;


-- Business scenario Q225 - Popular Stock Items by Colour
WITH RankedStockItems AS (
	SELECT C.ColorName
		, SI.StockItemName
		, SI.UnitPrice
		, ROW_NUMBER() OVER(PARTITION BY C.ColorName ORDER BY SI.UnitPrice DESC) AS Ranked
	FROM Warehouse.Colors C
	LEFT JOIN Warehouse.StockItems SI
	ON C.ColorID = SI.ColorID
)
SELECT RI.ColorName
	, RI.StockItemName
	, RI.UnitPrice
FROM RankedStockItems RI
WHERE RI.Ranked = 1
ORDER BY RI.ColorName
;