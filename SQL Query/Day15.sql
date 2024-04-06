-- Business scenario Q121
	, ST.Name AS TerritoryName
	, COUNT(SC.CustomerID) AS CustomerCount
FROM Sales.SalesTerritory ST
JOIN Sales.Customer SC 
ON ST.TerritoryID = SC.TerritoryID
JOIN Person.Address PA 
ON SC.CustomerID = PA.AddressID
GROUP BY ST.TerritoryID, ST.Name
	, MIN(HRE.HireDate) AS StartDate
	, DATEDIFF(YEAR, MIN(HRE.HireDate), GETDATE()) AS YearsWorked
FROM HumanResources.Employee HRE
GROUP BY HRE.BusinessEntityID
HAVING DATEDIFF(YEAR, MIN(HRE.HireDate), GETDATE()) >= 5
ORDER BY DATEDIFF(YEAR, MIN(HRE.HireDate), GETDATE()) DESC
;