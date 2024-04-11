-- Business scenario Q146 - Document Usage Analysis
SELECT PD.DocumentNode
	, PD.Title AS DocumentTitle
	, COUNT(PPD.ProductID) AS AssociatedProductCount
FROM Production.Document PD
LEFT JOIN Production.ProductDocument PPD
ON PD.DocumentNode = PPD.DocumentNode
GROUP BY PD.DocumentNode, PD.Title
ORDER BY COUNT(PPD.ProductID) DESC, PD.DocumentNode
;


-- Business scenario Q147 - Analysing Product Details and Unit Measures
SELECT PC.Name AS CategoryName
	, PS.Name AS SubcategoryName
	, P.Name AS ProductName
	, PM.Name AS ModelName
	, P.StandardCost
	, P.ListPrice
	, UM.Name AS UnitOfMeasure
	, P.Weight
FROM Production.Product P
INNER JOIN Production.ProductSubcategory PS
ON P.ProductSubcategoryID = PS.ProductSubcategoryID
INNER JOIN Production.ProductCategory PC
ON PS.ProductCategoryID = PC.ProductCategoryID
INNER JOIN Production.ProductModel PM
ON P.ProductModelID = PM.ProductModelID
INNER JOIN Production.ProductProductPhoto PPP
ON P.ProductID = PPP.ProductID
INNER JOIN Production.ProductPhoto PP
ON PPP.ProductPhotoID = PP.ProductPhotoID
INNER JOIN Production.UnitMeasure UM
ON P.SizeUnitMeasureCode = UM.UnitMeasureCode
ORDER BY PC.Name,  PS.Name,  P.Name
;


-- Business scenario 148 - Product and Subcategory Analysis
SELECT PC.Name AS CategoryName
	, PS.Name AS SubcategoryName
	, COUNT(P.ProductID) AS ProductCount
	, MAX(P.ListPrice) MaxListPrice
	, MIN(P.ListPrice) MinListPrice
	, AVG(P.ListPrice) AverageListPrice
	, UM.Name AS UnitOfMeasure
FROM Production.Product P
INNER JOIN Production.ProductSubcategory PS
ON P.ProductSubcategoryID = PS.ProductSubcategoryID
INNER JOIN Production.ProductCategory PC
ON PS.ProductCategoryID = PC.ProductCategoryID
INNER JOIN Production.UnitMeasure UM
ON P.SizeUnitMeasureCode = UM.UnitMeasureCode
GROUP BY PC.Name,  PS.Name,  UM.Name
ORDER BY PC.Name,  PS.Name
;


-- Business scenario Q149 - Product and Subcategory Inventory Analysis
SELECT PC.Name AS CategoryName
	, PS.Name AS SubcategoryName
	, COUNT(P.ProductID) AS ProductCount
	, SUM(P.StandardCost) AS TotalInventoryValue
	, UM.Name AS UnitOfMeasure
FROM Production.Product P
INNER JOIN Production.ProductSubcategory PS
ON P.ProductSubcategoryID = PS.ProductSubcategoryID
INNER JOIN Production.ProductCategory PC
ON PS.ProductCategoryID = PC.ProductCategoryID
INNER JOIN Production.UnitMeasure UM
ON P.SizeUnitMeasureCode = UM.UnitMeasureCode
GROUP BY PC.Name,  PS.Name,  UM.Name
ORDER BY SUM(P.StandardCost)
;


-- Business scenario Q150 - Product Sales Analysis by Subcategory
SELECT PC.Name AS CategoryName
	, PS.Name AS SubcategoryName
	, P.Name AS ProductName
	, SUM(OD.OrderQty) AS TotalUnitsSold
	, SUM(OH.TotalDue) AS TotalSalesAmount
	, AVG(OH.TotalDue * 1 / OD.OrderQty) AS AverageSalesPrice
FROM Production.Product P
INNER JOIN Production.ProductSubcategory PS
ON P.ProductSubcategoryID = PS.ProductSubcategoryID
INNER JOIN Production.ProductCategory PC
ON PS.ProductCategoryID = PC.ProductCategoryID
INNER JOIN Sales.SalesOrderDetail OD
ON P.ProductID = OD.ProductID
INNER JOIN Sales.SalesOrderHeader OH
ON OD.SalesOrderID = OH.SalesOrderID
GROUP BY PC.Name,  PS.Name,  P.Name
ORDER BY SUM(OH.TotalDue) DESC
;