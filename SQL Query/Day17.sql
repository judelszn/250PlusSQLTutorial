-- Business scenario Q131 - Product Life Cycle Analysis 
SELECT PP.ProductID
	, PP.Name AS ProductName
	, PP.SellStartDate
	, PP.DiscontinuedDate
	, CASE
		WHEN PP.SellStartDate IS NULL THEN 'Unknown'
		WHEN PP.DiscontinuedDate IS NULL THEN 'Introduction'
		WHEN PP.DiscontinuedDate IS NOT NULL 
		AND DATEDIFF(DAY,PP.SellStartDate,PP.DiscontinuedDate) <= 365 THEN 'Growth'
		WHEN PP.DiscontinuedDate IS NOT NULL 
		AND DATEDIFF(DAY,PP.SellStartDate,PP.DiscontinuedDate) <= 1095 THEN 'Maturity'
		ELSE 'Decline'
	  END AS LifeCycle	
FROM Production.Product PP
;


-- Business scenario Q132 - Customer Lifetime Value (CLV) Calculation (hard)SELECT SC.CustomerID	, COUNT(SOH.SalesOrderID) AS TotalOrders	, SUM(SOH.TotalDue) AS TotalSpent	, DATEDIFF(DAY,MIN(SOH.OrderDate),MAX(SOH.OrderDate)) AS DaysAsCustomer	, CASE		WHEN COUNT(SOH.SalesOrderID) > 0		AND DATEDIFF(DAY,MIN(SOH.OrderDate),MAX(SOH.OrderDate)) > 0 		THEN SUM(SOH.TotalDue) / NULLIF(DATEDIFF(DAY,MIN(SOH.OrderDate),MAX(SOH.OrderDate)), 0)		ELSE 0	  END AS AverageDailySpend	, SUM(SOH.TotalDue) / NULLIF(COUNT(SOH.SalesOrderID), 0) AS AverageOrderValue	, SUM(SOH.TotalDue) * 365 / NULLIF(DATEDIFF(DAY,MIN(SOH.OrderDate),Max(SOH.OrderDate)), 0) AS AnnualCLVFROM Sales.Customer SCINNER JOIN Sales.SalesOrderHeader SOHON SC.CustomerID = SOH.CustomerIDGROUP BY SC.CustomerID;-- Business scenario Q133 - Product Quality AnalysisSELECT PP.ProductID	, PP.Name AS ProductName	, AVG(PR.Rating) AS AverageRating	, COUNT(PR.ProductReviewID) AS TotalReviews	, SUM(CASE WHEN PR.Rating >= 4 THEN 1 ELSE 0 END) AS PositiveReviews	, SUM(CASE WHEN PR.Rating < 4 THEN 1 ELSE 0 END) AS NegativeReviewsFROM Production.Product PPINNER JOIN Production.ProductReview PRON PP.ProductID = PR.ProductIDGROUP BY PP.ProductID, PP.Name;-- Business scenario Q134 - Sales ForecastingSELECT YEAR(SOH.OrderDate) AS SalesYear	, SUM(SOH.TotalDue) AS AnnualSaleFROM Sales.SalesOrderHeader SOHWHERE SOH.OrderDate >= DATEADD(YEAR,-10,GETDATE())GROUP BY YEAR(SOH.OrderDate);-- Business scenario Q135 - E-commerce Conversion Rate OptimisationSELECT YEAR(SO.OrderDate) AS SalesYear	, COUNT(DISTINCT SO.CustomerID) AS TotalCustomer	, COUNT(OH.SalesOrderID) AS TotalOrders	, 100 * COUNT(OH.SalesOrderID) / COUNT(DISTINCT SO.CustomerID) AS ConversionRateFROM Sales.SalesOrderHeader SOLEFT JOIN Sales.SalesOrderHeader OHON SO.CustomerID = OH.CustomerIDWHERE YEAR(SO.OrderDate) >= YEAR(GETDATE()) - 20GROUP BY YEAR(SO.OrderDate);