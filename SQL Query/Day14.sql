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


-- Business scenario Q119