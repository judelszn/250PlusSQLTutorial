--  Business scenario Q106 - Sales Analysis for High-Value Customer Identification and Insights
SELECT TOP 10 SC.CustomerID
	, PP.FirstName
	, PP.LastName
	, SUM(SOH.TotalDue) AS TotalPurchase
FROM Sales.SalesOrderHeader SOH 
INNER JOIN Sales.Customer SC
ON SOH.CustomerID = SC.CustomerID
INNER JOIN Person.Person PP
ON SC.PersonID = PP.BusinessEntityID
GROUP BY SC.CustomerID, PP.FirstName, PP.LastName
ORDER BY SUM(SOH.TotalDue)
;


-- Business scenario Q107 - Inventory Optimisation through Value Analysis
SELECT SUM(PD.TotalCost) AS TotalInventaryValue
FROM (
		SELECT PP.ProductID
			, PP.Name AS ProductName
			, PP.StandardCost
			, SUM(POD.OrderQty) AS TotalOrderQuantity
			, MIN(PV.MinOrderQty) AS MinOrderQuantity
			, (SUM(POD.OrderQty)/MIN(PV.MinOrderQty)) AS ReorderCount
			, (SUM(POD.OrderQty)/MIN(PV.MinOrderQty)) * PP.StandardCost AS TotalCost
		FROM Production.Product PP
		LEFT JOIN Purchasing.ProductVendor PV
		ON PP.ProductID = PV.ProductID
		LEFT JOIN Purchasing.PurchaseOrderDetail POD
		ON PP.ProductID = POD.ProductID
		GROUP BY PP.ProductID, PP.Name, PP.StandardCost
		) PD
;


-- Business scenario Q108 - Identifying Slow-Moving and Obsolete Inventory
SELECT PP.ProductID
	, PP.Name AS ProductName
	, (SUM(SOD.OrderQty) - SUM(POD.OrderQty)) AS InventoryChange
FROM Production.Product PP
LEFT JOIN Sales.SalesOrderDetail SOD
ON PP.ProductID = SOD.ProductID
LEFT JOIN Purchasing.PurchaseOrderDetail POD 
ON PP.ProductID = POD.ProductID
GROUP BY PP.ProductID, PP.Name
HAVING (SUM(SOD.OrderQty) - SUM(POD.OrderQty)) <= 0
;


-- Business scenario Q109 - Supplier Performance Evaluation: Average Delivery Time Analysis
SELECT PPV.BusinessEntityID
	, PV.Name AS VendorName
	, AVG(DATEDIFF(DAY,POH.OrderDate,POH.ShipDate)) AS AverageDeliveryTime
FROM Purchasing.ProductVendor PPV
INNER JOIN Purchasing.PurchaseOrderDetail POD
ON PPV.ProductID = POD.ProductID
INNER JOIN Purchasing.PurchaseOrderHeader POH 
ON POD.PurchaseOrderID = POH.VendorID
INNER JOIN Purchasing.Vendor PV
ON PPV.BusinessEntityID = PV.BusinessEntityID
GROUP BY PPV.BusinessEntityID, PV.Name
;


-- Business scenario Q110 - Supplier Performance Evaluation: On-Time Delivery Percentage Analysis
SELECT PPV.BusinessEntityID
	, PV.Name AS VendorName
	, SUM
		(CASE WHEN DATEDIFF(DAY,POH.OrderDate,POH.ShipDate) <= 0 THEN 1 ELSE 0
			END) AS OnTimeDeliveries
	, COUNT(*) AS TotalDeliveries
	, (SUM
		(CASE WHEN DATEDIFF(DAY,POH.OrderDate,POH.ShipDate) <= 0 THEN 1 ELSE 0
			END) * 100) / NULLIF(COUNT(*),0) AS OnTimeDeliveryPercentage
FROM Purchasing.ProductVendor PPV
INNER JOIN Purchasing.PurchaseOrderDetail POD
ON PPV.ProductID = POD.ProductID
INNER JOIN Purchasing.PurchaseOrderHeader POH 
ON POD.PurchaseOrderID = POH.VendorID
INNER JOIN Purchasing.Vendor PV
ON PPV.BusinessEntityID = PV.BusinessEntityID
GROUP BY PPV.BusinessEntityID, PV.Name
;
