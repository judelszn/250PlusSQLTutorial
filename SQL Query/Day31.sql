-- Business scenario Q201 - Product Life Cycle Analysis
WITH ProductLifeCycle AS (
	SELECT P.ProductID
		, P.Name AS ProductName
		, P.SellStartDate
		, P.DiscontinuedDate
		, CASE
			WHEN P.SellStartDate IS NULL THEN 'Unknown'
			WHEN P.DiscontinuedDate IS NULL THEN 'Introduction'
			WHEN P.DiscontinuedDate IS NOT NULL 
			AND DATEDIFF(DAY,P.SellStartDate,P.DiscontinuedDate) <= 365 THEN 'Growth'
			WHEN P.DiscontinuedDate IS NOT NULL 
			AND DATEDIFF(DAY,P.SellStartDate,P.DiscontinuedDate) <= 1095 THEN 'Maturity'
			ELSE 'Decline'
		 END AS LifeCycleStage
	FROM Production.Product P
)
SELECT LC.ProductID
	, LC.ProductName
	, LC.SellStartDate
	, LC.DiscontinuedDate
	, LC.LifeCycleStage
FROM ProductLifeCycle LC
ORDER BY LC.ProductID
;


-- Business scenario Q202 - Employee Productivity Ranking
WITH EmployeeProductivity AS (
	SELECT E.BusinessEntityID AS EmployeeID
		, COUNT(OH.SalesOrderID) AS TotalSalesOrders
	FROM Sales.SalesPerson SP
	INNER JOIN HumanResources.Employee E
	ON SP.BusinessEntityID = E.BusinessEntityID
	LEFT JOIN Sales.SalesOrderHeader OH 
	ON SP.BusinessEntityID = OH.SalesPersonID
	GROUP BY E.BusinessEntityID
)
SELECT EP.EmployeeID
	, EP.TotalSalesOrders
	, RANK() OVER(ORDER BY EP.TotalSalesOrders DESC) AS ProductivityRank
FROM EmployeeProductivity EP
ORDER BY ProductivityRank DESC
;


-- Business scenario Q203 - Customer Address Validation for Shipping Efficiency
WITH IncorrectAddressCustomers AS (
	SELECT OH.CustomerID
		, PA.City
		, PA.StateProvinceID
		, PA.PostalCode
		, COUNT(OH.SalesOrderID) AS OrderCount
	FROM Sales.SalesOrderHeader OH
	INNER JOIN Person.Address PA
	ON OH.ShipToAddressID = PA.AddressID
	WHERE PA.City IS NOT NULL OR PA.StateProvinceID IS NOT NULL OR PA.PostalCode IS NOT NULL
	GROUP BY OH.CustomerID, PA.City, PA.StateProvinceID, PA.PostalCode 
)
SELECT IAC.CustomerID
	, MAX(COALESCE(IAC.City,'N/A')) AS City
	, MAX(COALESCE(IAC.StateProvinceID,'N/A')) AS StateProvinceID
	, MAX(COALESCE(IAC.PostalCode,'N/A')) AS PostalCode
	, MAX(COALESCE(IAC.OrderCount,'N/A')) AS OrderCount
FROM IncorrectAddressCustomers IAC
GROUP BY IAC.CustomerID
ORDER BY MAX(COALESCE(IAC.OrderCount,'N/A')) DESC
;


-- Business scenario Q204 - Sales Region Analysis for Targeted Marketing
WITH RegionSales AS (
	SELECT PA.StateProvinceID
		, SUM(OD.LineTotal) AS TotalSalesAmount
		, COUNT(DISTINCT OH.SalesOrderID) AS OrderCount
	FROM Sales.SalesOrderHeader OH
	INNER JOIN Sales.SalesOrderDetail OD
	ON OH.SalesOrderID = OD.SalesOrderID
	INNER JOIN Person.Address PA
	ON OH.ShipToAddressID = PA.AddressID
	GROUP BY PA.StateProvinceID
)
SELECT RS.StateProvinceID
	, MAX(SP.Name) AS StateProvinceName
	, SUM(RS.TotalSalesAmount) AS TotalSalesAmount
	, SUM(RS.OrderCount) AS OrderCount
FROM RegionSales RS
LEFT JOIN Person.StateProvince SP
ON RS.StateProvinceID = SP.StateProvinceID
GROUP BY RS.StateProvinceID
ORDER BY SUM(RS.TotalSalesAmount) DESC
;


-- Business scenario Q205 - Department Employee History Analysis
WITH DepartmentHistoryCTE AS (
	SELECT DH.DepartmentID
		, D.Name AS DepartmentName
		, DH.StartDate
		, DH.EndDate
		, DATEDIFF(DAY,DH.StartDate,DH.EndDate) AS DaysInDepartment
	FROM HumanResources.EmployeeDepartmentHistory DH
	INNER JOIN HumanResources.Department D
	ON DH.DepartmentID = D.DepartmentID
)
SELECT CTE.DepartmentName
	, AVG(CTE.DaysInDepartment) AS AverageDaysInDepartment
	, MAX(CTE.DaysInDepartment) AS MaximumDaysInDepartment
	, MIN(CTE.DaysInDepartment) AS MinimumDaysInDepartment
FROM DepartmentHistoryCTE CTE
GROUP BY CTE.DepartmentName
ORDER BY AVG(CTE.DaysInDepartment)
;