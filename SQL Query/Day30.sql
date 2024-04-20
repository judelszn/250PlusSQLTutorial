-- Business scenario Q196 - Sales Forecasting
WITH SalesForecast AS (
	SELECT YEAR(OH.OrderDate) AS SalesYear
		, SUM(OH.TotalDue) AS AnnualSales
	FROM Sales.SalesOrderHeader OH
	WHERE OH.OrderDate >= DATEADD(YEAR,-10, GETDATE())
	GROUP BY YEAR(OH.OrderDate)
)
SELECT YEAR(GETDATE()) AS ForecastYear
	, SF.SalesYear
	, SF.AnnualSales
FROM SalesForecast SF
WHERE SF.SalesYear BETWEEN YEAR(GETDATE()) AND YEAR(GETDATE()) -8
ORDER BY SF.SalesYear
;


-- Business scenario Q197 - Product Quality Analysis
WITH ProductQualityAnalysis AS (
	SELECT P.ProductID
		, P.Name AS ProductName
		, AVG(PR.Rating) AS AverageRating
		, COUNT(PR.ProductReviewID) AS TotalReviews
		, SUM(CASE WHEN PR.Rating >= 4 THEN 1 ELSE 0 END) AS PositiveReview
		, SUM(CASE WHEN PR.Rating < 4 THEN 1 ELSE 0 END) AS NegativeReview
	FROM Production.Product P
	LEFT JOIN Production.ProductReview PR
	ON P.ProductID = PR.ProductID
	GROUP BY P.ProductID, P.Name
)
SELECT QA.ProductID
	, QA.ProductName
	, QA.TotalReviews
	, QA.PositiveReview
	, QA.PositiveReview
	, CASE
		WHEN QA.AverageRating >= 4.5 THEN 'Excellent'
		WHEN QA.AverageRating >= 4 THEN 'Good'
		WHEN QA.AverageRating >= 3 THEN 'Average'
		ELSE 'Below Average'
	  END AS QualityRating
FROM ProductQualityAnalysis QA
ORDER BY AverageRating DESC
;


-- Business scenario Q198 - Customer Retention AnalysisWITH CustomerRetention AS (	SELECT C.CustomerID		, MIN(OH.OrderDate) AS FirstPurchaseDate		, MAX(OH.OrderDate) AS LatestPurchaseDate		, DATEDIFF(DAY, MIN(OH.OrderDate), MAX(OH.OrderDate)) AS DaysSinceFirstPurchase		, CASE			WHEN COUNT(OH.SalesOrderID) > 1 THEN 'Returning Customer'			ELSE 'New Customer'		  END AS CustomerType	FROM Sales.Customer C	LEFT JOIN Sales.SalesOrderHeader OH	ON C.CustomerID = OH.CustomerID	GROUP BY C.CustomerID)SELECT CR.CustomerType	, COUNT(CR.CustomerID) AS TotalCustomer	, SUM(CASE WHEN CR.DaysSinceFirstPurchase > 365 THEN 1 ELSE 0 END) AS RetainedCustomer	, 100 * SUM(CASE WHEN DaysSinceFirstPurchase > 365 THEN 1 ELSE 0 END) / COUNT(CR.CustomerID)	  AS RetentionRateFROM CustomerRetention CRGROUP BY CR.CustomerType;-- Business scenario Q199 - Promotion Effectiveness AnalysisWITH PromotionAnalysis AS (	SELECT SO.SpecialOfferID		, SO.Description AS PromotionDescription		, SO.DiscountPct		, COUNT(DISTINCT OH.CustomerID) AS CustomerAquired		, SUM(OH.TotalDue) AS TotalSalesAmount	FROM Sales.SpecialOffer SO	LEFT JOIN Sales.SalesOrderDetail OD	ON SO.SpecialOfferID = OD.SpecialOfferID	INNER JOIN Sales.SalesOrderHeader OH 	ON OD.SalesOrderID = OH.SalesOrderID	GROUP BY SO.SpecialOfferID, SO.Description, SO.DiscountPct )SELECT PA.SpecialOfferID	, PA.PromotionDescription	, PA.DiscountPct	, PA.CustomerAquired	, PA.TotalSalesAmountFROM PromotionAnalysis PAORDER BY PA.TotalSalesAmount DESC;-- Business scenario Q200 - Customer Lifetime Value (CLV) CalculationWITH CustomerCLV AS (	SELECT C.CustomerID		, COUNT(OH.SalesOrderID) AS TotalOrders		, SUM(OH.TotalDue) AS TotalSpent		, DATEDIFF(DAY, MIN(OH.OrderDate), MAX(OH.OrderDate)) AS DaysCustomer		, CASE			WHEN COUNT(OH.SalesOrderID) > 0 			AND DATEDIFF(DAY, MIN(OH.OrderDate), MAX(OH.OrderDate)) > 0			THEN SUM(OH.TotalDue) / NULLIF(DATEDIFF(DAY, MIN(OH.OrderDate), MAX(OH.OrderDate)),0)			ELSE 0		  END AS AverageDailySpend		, SUM(OH.TotalDue) / NULLIF(COUNT(OH.SalesOrderID),0) AS AverageOrderValue		, SUM(OH.TotalDue) / NULLIF(DATEDIFF(DAY, MIN(OH.OrderDate), MAX(OH.OrderDate)),0) AS AnnualCLV	FROM Sales.Customer C	LEFT JOIN Sales.SalesOrderHeader OH	ON C.CustomerID = OH.CustomerID	GROUP BY C.CustomerID)SELECT CLV.CustomerID	, CLV.TotalOrders	, CLV.TotalSpent	, CLV.DaysCustomer	, CLV.AverageDailySpend	, CLV.AverageOrderValue	, CLV.AnnualCLVFROM CustomerCLV CLVORDER BY CLV.AnnualCLV DESC;