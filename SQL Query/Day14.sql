-- Business scenario Q116
SELECT SUM(PP.StandardCost * PPI.Quantity) AS TotalInventoryCost
FROM Production.Product PP
INNER JOIN Production.ProductInventory PPI
ON PP.ProductID = PPI.ProductID
;


-- Business scenario Q117
SELECT LocationID
	, Name AS LocationName
	, SUM(CostRate) AS TotalShippingCost
FROM Production.Location
GROUP BY LocationID, Name
;


-- Business scenario Q118
SELECT LocationID
	, LocationName
	, TotalShippingCost
FROM (SELECT PL.LocationID
		, PL.Name AS LocationName
		, SUM(PL.CostRate) AS TotalShippingCost
	  FROM Production.Location PL
	  GROUP BY PL.LocationID, PL.Name) Subquery
ORDER BY TotalShippingCost DESC
;


-- Business scenario Q119SELECT TOP 5 POD.ProductID	, PP.Name AS ProductName	, COUNT(*) AS DelayedPurchaseOrdersFROM Purchasing.PurchaseOrderDetail PODINNER JOIN Production.Product PPON POD.ProductID = PP.ProductIDWHERE POD.DueDate < GETDATE()GROUP BY POD.ProductID, PP.NameORDER BY DelayedPurchaseOrders DESC;-- Business scenario Q120SELECT ST.TerritoryID	, ST.Name AS TerritoryName	, SUM(SOH.TotalDue) AS TotalSalesFROM Sales.SalesOrderHeader SOHINNER JOIN Sales.Customer SC ON SOH.CustomerID = SC.CustomerIDINNER JOIN Sales.SalesTerritory STON SC.TerritoryID = ST.TerritoryIDGROUP BY ST.TerritoryID, ST.NameORDER BY TotalSales DESC;