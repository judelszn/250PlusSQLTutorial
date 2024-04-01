-- Business scenario Q101 - Retrieving Order Details with Customer and SalesmanSELECT SOH.SalesOrderNumber	, SOH.OrderDate	, SOD.OrderQty	, PP.FirstName	, PP.PersonType	, SP.CommissionPctFROM Sales.SalesOrderHeader SOHINNER JOIN Sales.SalesOrderDetail SODON SOH.SalesOrderID = SOD.SalesOrderIDINNER JOIN Sales.Customer SCON SOH.CustomerID = SC.CustomerIDINNER JOIN Sales.SalesPerson SPON SOH.TerritoryID = SP.TerritoryIDINNER JOIN Person.Person PPON SP.BusinessEntityID = PP.BusinessEntityID;-- Business scenario Q102 - Calculating Commission and Margin for ProductsSELECT Color
	, StandardCost
	, StandardCost * 0.14790 AS COMMISSION
	, CASE
		WHEN Color = 'BLACK' THEN ((StandardCost * 1.22) - StandardCost)
		WHEN Color = 'RED' THEN ((StandardCost * 0.88) - StandardCost)
		WHEN Color = 'SILVER' THEN ((StandardCost * 1.15) - StandardCost)
		WHEN Color = 'MULTI' THEN ((StandardCost * 1.05) - StandardCost)
		WHEN Color = 'WHITE' THEN ((StandardCost * 2) / (SQRT(StandardCost)) * (StandardCost)) - StandardCost
		ELSE StandardCost * 1
	 END AS Margin
FROM Production.Product
WHERE Color IS NOT NULL
;


-- Business scenario Q103 - Total Profit Calculation for Product Portfolio Analysis
SELECT PP.ProductID
	, SUM (SOD.LineTotal) AS TotalSales
	, SUM ((SOD.UnitPrice - SOD.UnitPriceDiscount) * SOD.OrderQty) AS TotalCost
	, SUM (SOD.LineTotal - (SOD.UnitPrice - SOD.UnitPriceDiscount) * SOD.OrderQty) AS TotalProfit
FROM Production.Product PP
INNER JOIN Sales.SalesOrderDetail SOD
ON PP.ProductID = SOD.ProductID
GROUP BY PP.ProductID
;


-- Business scenario Q104 - Sales Analysis for Identifying Top-Selling Products and Trends
SELECT *
FROM 
;