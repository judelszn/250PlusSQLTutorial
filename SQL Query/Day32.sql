-- Business scenario Q206 - Department Change Analysi
WITH DepartmentChanges AS (
	SELECT DH.DepartmentID
		, D.Name AS DepartmentName
		, DH.StartDate
		, DH.EndDate
		, ROW_NUMBER() OVER(PARTITION BY DH.DepartmentID ORDER BY DH.StartDate) AS ChangeNumber
	FROM HumanResources.EmployeeDepartmentHistory DH
	INNER JOIN HumanResources.Department D
	ON DH.DepartmentID = D.DepartmentID
)
SELECT DC.DepartmentName
	, COUNT(DISTINCT DepartmentID) AS TotalDepartments
	, MAX(DC.ChangeNumber) AS MaximumDepartmentChanges
	, AVG(dc.ChangeNumber) AS AverageDepartmentChanges
FROM DepartmentChanges DC
GROUP BY DC.DepartmentName
ORDER BY AVG(dc.ChangeNumber) DESC
;


-- Business scenario Q207 - Employee Department Tenure
WITH DepartmentTenure AS (
	SELECT DH.BusinessEntityID
		, D.Name AS DepartmentName
		, DATEDIFF(YEAR, DH.StartDate, ISNULL(DH.EndDate, GETDATE())) AS TenureInYears
	FROM HumanResources.EmployeeDepartmentHistory DH
	INNER JOIN HumanResources.Department D
	ON DH.DepartmentID = D.DepartmentID
)
SELECT DT.DepartmentName
	, AVG(DT.TenureInYears) AS AverageTenureInYears
FROM DepartmentTenure DT
GROUP BY DT.DepartmentName
ORDER BY  AVG(DT.TenureInYears) DESC
;


-- Business scenario Q208 - Employee Shift Analysis
WITH DepartmentShift AS (
	SELECT DH.BusinessEntityID
		, S.Name AS ShiftName
		, COUNT(*) AS ShiftCount
	FROM HumanResources.EmployeeDepartmentHistory DH
	INNER JOIN HumanResources.Shift S
	ON DH.ShiftID = S.ShiftID
	GROUP BY DH.BusinessEntityID, S.Name 
)
SELECT DS.ShiftName
	, COUNT(DISTINCT DS.BusinessEntityID) AS EmployeeCount
	, SUM(DS.ShiftCount) AS TotalShifts
FROM DepartmentShift DS
GROUP BY DS.ShiftName
ORDER BY SUM(DS.ShiftCount) DESC
;


-- Business scenario Q209 - Product Model Localisation Check
SELECT PM.ProductModelID
	, PM.Name AS ProductModelName
	, C.CultureID
	, C.Name AS CultureName
	, CASE
		WHEN DC.ProductDescriptionID IS NOT NULL THEN 'Localized'
		ELSE 'MissingLocalization'
	  END AS LocalizationStatus		
FROM Production.ProductModel PM
CROSS JOIN Production.Culture C
INNER JOIN Production.ProductModelProductDescriptionCulture DC
ON C.CultureID = DC.CultureID
ORDER BY PM.ProductModelID, C.CultureID
;


-- Business scenario Q210 - Inventory Valuation and Usage Analysis
WITH InventoryAnalysis AS (
	SELECT P.ProductID
		, P.Name AS ProductName
		, SUM(CH.StandardCost * BM.PerAssemblyQty) AS InventoryValuation
		, SUM(WO.OrderQty) AS QuantityUsedInProduction
		, SUM(TH.Quantity) AS QuantitySold
	FROM Production.Product P
	INNER JOIN Production.BillOfMaterials BM
	ON P.ProductID = BM.ProductAssemblyID
	LEFT JOIN Production.ProductCostHistory CH
	ON P.ProductID = CH.ProductID
	LEFT JOIN Production.WorkOrder WO
	ON P.ProductID = WO.ProductID
	LEFT JOIN Production.TransactionHistory TH
	ON P.ProductID = TH.ProductID
	WHERE TH.TransactionType = 'S'
	GROUP BY P.ProductID, P.Name
)
SELECT IA.ProductName
	, IA.InventoryValuation
	, IA.QuantityUsedInProduction
	, IA.QuantitySold
FROM InventoryAnalysis IA
;