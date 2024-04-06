-- Business scenario Q121SELECT ST.TerritoryID
	, ST.Name AS TerritoryName
	, COUNT(SC.CustomerID) AS CustomerCount
FROM Sales.SalesTerritory ST
JOIN Sales.Customer SC 
ON ST.TerritoryID = SC.TerritoryID
JOIN Person.Address PA 
ON SC.CustomerID = PA.AddressID
GROUP BY ST.TerritoryID, ST.Name;