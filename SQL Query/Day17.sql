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


-- Business scenario Q132 - Customer Lifetime Value (CLV) Calculation (hard)