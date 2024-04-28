-- Business scenario Q211 - Cost Analysis and Profitability of Product Models
WITH ProductModelAnalysis AS (
	SELECT PM.ProductModelID
		, PM.Name AS ProductName
		, SUM(ch.StandardCost * BM.PerAssemblyQty) AS TotalCost
		, SUM(TH.Quantity * PH.ListPrice) AS TotalRevenue
	FROM Production.ProductModel PM
	LEFT JOIN Production.Product P
	ON PM.ProductModelID = P.ProductModelID
	LEFT JOIN Production.BillOfMaterials BM
	ON P.ProductID = BM.ProductAssemblyID
	LEFT JOIN Production.ProductCostHistory CH
	ON P.ProductID = CH.ProductID
	LEFT JOIN Production.TransactionHistory TH
	ON P.ProductID = TH.ProductID
	LEFT JOIN Production.ProductListPriceHistory PH
	ON P.ProductID = PH.ProductID
	WHERE TH.TransactionType = 'S'
	GROUP BY PM.ProductModelID, PM.Name
)
SELECT MA.ProductName
	, MA.TotalCost
	, MA.TotalRevenue
	, (MA.TotalRevenue - MA.TotalCost) AS Profit
FROM ProductModelAnalysis MA
;


-- Business scenario Q212 - Product Description Localisation Gap Analysis
SELECT DISTINCT PDPC.CultureID
	, PDPC.CultureName
	, PDPC.DescriptionStatus
FROM (
	SELECT DC.CultureID
		, C.Name AS CultureName
		, CASE
			WHEN PD.Description IS NULL THEN 'Missing'
			WHEN PD.Description = ' ' THEN 'Incomplete'
			ELSE 'Complete'
		 END AS DescriptionStatus
	FROM Production.ProductModelProductDescriptionCulture DC
	INNER JOIN Production.Culture C
	ON DC.CultureID = C.CultureID
	LEFT JOIN Production.ProductDescription PD
	ON DC.ProductDescriptionID = PD.ProductDescriptionID
) AS PDPC
ORDER BY PDPC.CultureID, PDPC.DescriptionStatus 
;


-- Business scenario Q213 - Work Order Scrap Analysis