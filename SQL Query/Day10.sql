-- Business scenario Q91 - Product Promotion Analysis
SELECT CP.ProductID
	, CP.ProductDescription
	, CP.Cost
	, SUM(CO.OrderQuantity * CP.Cost) AS TotalRevenue
	, SUM(CO.OrderQuantity) AS TotalQuantitySold
	, (((SUM(CO.OrderQuantity * CP.Cost) - COUNT(CO.OrderID*CP.Cost))/(CO.OrderQuantity*CP.Cost)) * 100)
		AS ProfitMargin
	, CASE
		WHEN SUM(CO.OrderQuantity * CP.Cost) > 500 THEN 'High Sales'
		ELSE 'Low Sales'
	  END AS SalesCategory
	, CASE 
		WHEN SUM(CO.OrderQuantity) > 100 THEN 'High Demand'
		ELSE 'Low Demand'
	  END AS DemandCategory
	, CASE
		WHEN (((SUM(CO.OrderQuantity * CP.Cost) - COUNT(CO.OrderID * CP.Cost))/(CO.OrderQuantity*CP.Cost)) * 100) >= 30 
		THEN 'High Profit Margin'
		ELSE 'Low Profit Margin'
	  END AS ProfitMarginCategory
	, CASE
		WHEN SUM(CO.OrderQuantity) = 0 THEN 'Not Sold'
		ELSE 'Sold'
	  END AS SoldStatus
FROM CustomerTab.CustomerOrdersTabl CO
INNER JOIN CustomerTab.CustomerProductTabl CP
ON CO.ProductID = CP.ProductID
GROUP BY CP.ProductDescription, CP.Cost
HAVING SUM(CO.OrderQuantity * CP.Cost) > 500
OR SUM(CO.OrderQuantity) > 100
OR (((SUM(CO.OrderQuantity * CP.Cost) - COUNT(CO.OrderID * CP.Cost))/(CO.OrderQuantity * CP.Cost)) * 100) >= 30
OR SUM(OrderQuantity) = 0
;


-- Business scenario Q92 - Product Selection and Pricing Analysis
SELECT PP.ProductID
	, PP.Name
	, PP.Color
	, PP.ListPrice AS Price
FROM Production.Product PP
WHERE PP.Color IS NOT NULL
AND PP.Color NOT IN ('Silver','Black', 'White')
AND PP.ListPrice BETWEEN 75 AND 750
ORDER BY ListPrice DESC
;


-- Business scenario Q93 - Identifying the Most Expensive Products with a Specific Product Number
SELECT TOP 10 PP.ProductID
	, PP.Name
	, PP.Color
	, PP.ListPrice
	, PP.ProductNumber
FROM Production.Product PP
WHERE PP.ProductNumber LIKE 'BK%'
ORDER BY PP.ListPrice DESC
;


-- Business scenario Q94 - Contact Information Analysis
SELECT DISTINCT FirstName
	, LastName
	, CONCAT(LEFT(LastName,4),'.','@adventureworks.com') AS EmailAddress
	, CONCAT(FirstName, ' ',LastName) AS FullName
	, LEN(CONCAT(FirstName, ' ',LastName)) AS NameLength
FROM Person.Person
WHERE LEFT(FirstName,1) = LEFT(LastName,1)
;


-- Business scenario Q95 - Product Subcategory Manufacturing Analysis
SELECT PP.ProductID
	, PP.Name
	, PP.DaysToManufacture
FROM Production.Product PP
INNER JOIN Production.ProductSubcategory PS
ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
WHERE PP.DaysToManufacture >= 3
;


-- Business scenario Q96 - Price Segmentation for Products
SELECT ProductID
	, Color
	, CASE
		WHEN  ListPrice < 200 THEN 'Low Value'
		WHEN ListPrice BETWEEN 201 AND 750 THEN 'Mid Value'
		WHEN ListPrice BETWEEN 751 AND 1250 THEN 'Mid-High Value'
		ELSE 'High Value'
	  END AS PriceSegment
FROM Production.Product
WHERE Color IN ('Black','Silver','Red')
;


-- Business scenario Q97 - Long Service Award Eligibility Analysis
SELECT COUNT(DATEDIFF(YEAR,HireDate,GETDATE()) + 5) AS NumberForAward
FROM HumanResources.Employee
WHERE (DATEDIFF(YEAR,HireDate,GETDATE()) + 5) >= 20
;


-- Business scenario Q98 - Calculating Years to Retirement for Employees
SELECT BusinessEntityID
	, 65 - DATEDIFF(YEAR,BirthDate,GETDATE()) AS YearsToRetire
FROM HumanResources.Employee
WHERE 65 - DATEDIFF(YEAR,BirthDate,GETDATE()) > 0
;


-- Business scenario Q99 - Implementing a New Pricing Policy
SELECT PP.ProductID
	, PP.ListPrice AS OldPrice
	, CASE 
		WHEN PP.Color = 'White' THEN CAST(PP.ListPrice * 1.08 AS Decimal(18,3))
		WHEN PP.Color = 'Yellow' THEN CAST(PP.ListPrice * 1.075 AS Decimal(18,3))
		WHEN PP.Color = 'Black' THEN CAST(PP.ListPrice * 1.172 AS Decimal(18,3))
		WHEN PP.Color IN ('Silver','Silver/Black','Blue') THEN CAST(SQRT(PP.ListPrice) * 2 AS Decimal(18,3))
		ELSE PP.ListPrice
	  END AS NewPrice
	, CASE 
		WHEN PP.Color = 'White' THEN CAST(PP.ListPrice * 1.08 * 0.375 AS Decimal(18,3))
		WHEN PP.Color = 'Yellow' THEN CAST(PP.ListPrice * 1.075 * 0.375 AS Decimal(18,3))
		WHEN PP.Color = 'Black' THEN CAST(PP.ListPrice * 1.172 * 0.375 AS Decimal(18,3))
		WHEN PP.Color IN ('Silver','Silver/Black','Blue') THEN CAST(SQRT(PP.ListPrice) * 2 AS Decimal(18,3))
		ELSE PP.ListPrice
	  END AS Commission
FROM Production.Product PP
WHERE PP.Color IS NOT NULL
;


-- Business scenario Q100 - Retrieving Sales Personnel Information
SELECT CONCAT(PP.FirstName,' ',PP.LastName) AS SalesPerson
	, HE.JobTitle
	, HE.HireDate
	, HE.SickLeaveHours
	, ST.Name AS Region
	, SP.SalesQuota
FROM Sales.SalesPerson SP
INNER JOIN Person.Person PP
ON SP.BusinessEntityID = PP.BusinessEntityID
INNER JOIN HumanResources.Employee HE
ON SP.BusinessEntityID = HE.BusinessEntityID
LEFT JOIN Sales.SalesTerritory ST
ON SP.TerritoryID = ST.TerritoryID
;