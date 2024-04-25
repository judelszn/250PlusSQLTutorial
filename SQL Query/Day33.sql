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


-- Business scenario Q213 - Work Order Scrap AnalysisWITH ScrapSummary AS (	SELECT SR.ScrapReasonID		, SR.Name AS ScrapReason		, COUNT(WO.WorkOrderID) AS WorkOrderCount	FROM Production.ScrapReason SR	LEFT JOIN Production.WorkOrder WO	ON SR.ScrapReasonID = WO.ScrapReasonID	GROUP BY SR.ScrapReasonID, SR.Name)SELECT SS.ScrapReason	, SS.WorkOrderCountFROM ScrapSummary SSORDER BY SS.WorkOrderCount DESC;-- Business scenario Q214 - Work Order Scrap Rate AnalysisWITH ScrapRateSummary AS (	SELECT P.ProductID		, P.Name AS ProductName		, SR.Name AS ScrapReason		, COUNT(WO.WorkOrderID) AS ScrapCount		, CASE			WHEN COUNT(DISTINCT WO.WorkOrderID) = 0 THEN 0			ELSE COUNT(WO.WorkOrderID) * 1.0 / COUNT(DISTINCT WO.WorkOrderID)		  END AS ScrapeRate	FROM Production.Product P	LEFT JOIN Production.WorkOrder WO	ON P.ProductID = WO.ProductID	LEFT JOIN Production.ScrapReason SR	ON WO.ScrapReasonID = SR.ScrapReasonID	GROUP BY P.ProductID, P.Name, SR.Name)SELECT RS.ProductName	, RS.ScrapReason	, RS.ScrapeRateFROM ScrapRateSummary RSWHERE RS.ScrapeRate IS NOT NULLORDER BY RS.ProductName, RS.ScrapeRate DESC;-- Business scenario Q215 - Calculating Total Scrap Costs by ProductWITH ScrapCost AS (	SELECT P.ProductID		, P.Name AS ProductName		, ISNULL(SR.Name, 'No Scrap Reason') AS ScrapReason		, SUM(ISNULL(WO.ScrappedQty,0) * ISNULL(P.StandardCost,0)) AS TotalScrapCost	FROM Production.Product P	LEFT JOIN Production.WorkOrder WO	ON P.ProductID = WO.ProductID	LEFT JOIN Production.ScrapReason SR	ON WO.ScrapReasonID = SR.ScrapReasonID	GROUP BY P.ProductID, P.Name, SR.Name)SELECT SC.ProductName	, SC.ScrapReason	, SC.TotalScrapCostFROM ScrapCost SCORDER BY SC.ProductName, SC.TotalScrapCost DESC;