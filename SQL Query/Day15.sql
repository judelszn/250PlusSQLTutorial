-- Business scenario Q121SELECT ST.TerritoryID
	, ST.Name AS TerritoryName
	, COUNT(SC.CustomerID) AS CustomerCount
FROM Sales.SalesTerritory ST
JOIN Sales.Customer SC 
ON ST.TerritoryID = SC.TerritoryID
JOIN Person.Address PA 
ON SC.CustomerID = PA.AddressID
GROUP BY ST.TerritoryID, ST.Name;-- Business scenario Q122SELECT (COUNT(DISTINCT HRE.BusinessEntityID) * 1.0 / (DATEDIFF(YEAR,MIN(HRE.HireDate),		GETDATE()) + 1) 	) AS TurnOverRateFROM HumanResources.Employee HRE;-- Business scenario Q123SELECT HRD.Name AS DepartmentName	, (COUNT(DISTINCT HRE.BusinessEntityID) * 1.0 / (DATEDIFF(YEAR,MIN(HRE.HireDate),		GETDATE()) + 1) 	) AS TurnOverRateFROM HumanResources.Employee HREINNER JOIN HumanResources.EmployeeDepartmentHistory EDHON HRE.BusinessEntityID = EDH.BusinessEntityIDINNER JOIN HumanResources.Department HRDON EDH.DepartmentID = HRD.DepartmentIDGROUP BY HRD.NameORDER BY TurnOverRate DESC;-- Business scenario Q124SELECT TOP 5 HRE.BusinessEntityID	, (MAX(EPH.Rate) - MIN(EPH.Rate)) AS PayIncreaseFROM HumanResources.Employee HREINNER JOIN HumanResources.EmployeePayHistory EPHON HRE.BusinessEntityID = EPH.BusinessEntityIDGROUP BY HRE.BusinessEntityIDORDER BY PayIncrease DESC;-- Business scenario Q125 - Long Service Award CalculationSELECT HRE.BusinessEntityID	, HRE.BusinessEntityID	, HRE.HireDate	, DATEDIFF(YEAR,HRE.HireDate,GETDATE()) AS YearWithCompanyFROM HumanResources.Employee HREWHERE DATEDIFF(YEAR,HRE.HireDate,GETDATE()) >= 5ORDER BY DATEDIFF(YEAR,HRE.HireDate,GETDATE()) DESC;-- ORSELECT HRE.BusinessEntityID
	, MIN(HRE.HireDate) AS StartDate
	, DATEDIFF(YEAR, MIN(HRE.HireDate), GETDATE()) AS YearsWorked
FROM HumanResources.Employee HRE
GROUP BY HRE.BusinessEntityID
HAVING DATEDIFF(YEAR, MIN(HRE.HireDate), GETDATE()) >= 5
ORDER BY DATEDIFF(YEAR, MIN(HRE.HireDate), GETDATE()) DESC
;