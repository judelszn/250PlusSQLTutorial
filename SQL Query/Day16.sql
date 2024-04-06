-- Business scenario Q126 - Retirement Age Analysis
DECLARE @RetirementAge INT = 65

SELECT HRE.BusinessEntityID
	, HRE.HireDate
	, DATEDIFF(YEAR,HRE.HireDate,GETDATE()) AS YearsWorked
	, CASE
		WHEN (DATEDIFF(YEAR,HRE.HireDate,GETDATE()) + @RetirementAge) >= @RetirementAge THEN 0
		ELSE @RetirementAge - (DATEDIFF(YEAR,HRE.HireDate,GETDATE()) + @RetirementAge)
	  END AS YearsToRetire
FROM HumanResources.Employee HRE
;


-- Business scenario Q127 - Employee Productivity RankingSELECT HRE.BusinessEntityID	, COUNT(SOH.SalesOrderID) AS TotalSalesOrdersFROM Sales.SalesPerson SPINNER JOIN HumanResources.Employee HREON SP.BusinessEntityID = HRE.BusinessEntityIDLEFT JOIN Sales.SalesOrderHeader SOH ON SP.BusinessEntityID = SOH.SalesOrderIDGROUP BY HRE.BusinessEntityID;-- Business scenario Q128 - Marketing Campaign EffectivenessSELECT SO.SpecialOfferID	, COUNT(DISTINCT SOH.SalesOrderID) AS TotalCustomerReached	, SUM(CASE			WHEN SOH.SalesOrderID IS NOT NULL THEN 1			ELSE 0		  END) AS CustomerConverted	, NULLIF(SUM(CASE			WHEN SOH.SalesOrderID IS NOT NULL THEN 1			ELSE 0		  END) * 100/NULLIF(COUNT(DISTINCT SOH.SalesOrderID),0), 0) AS ConversionRateFROM Sales.SpecialOffer SOLEFT JOIN Sales.SalesOrderDetail SOHON SO.SpecialOfferID = SOH.SpecialOfferIDGROUP BY SO.SpecialOfferID;-- Business scenario Q129 - Promotion Effectiveness AnalysisSELECT SO.SpecialOfferID	, SO.Description AS PromotionDescription	, SO.DiscountPct	, COUNT(DISTINCT SOD.SalesOrderID) AS CustomerAcquired	, SUM(SOD.LineTotal) AS TotalSalesAmountFROM Sales.SpecialOffer SOLEFT JOIN Sales.SalesOrderDetail SODON SO.SpecialOfferID = SOD.SpecialOfferIDGROUP BY SO.SpecialOfferID, SO.Description, SO.DiscountPct;-- Business scenario Q130 - Customer Retention AnalysisSELECT SC.CustomerID	, MIN(SOH.OrderDate) AS FirstPurchaseDate	, MAX(SOH.OrderDate) AS LatestPurchaseDate	, DATEDIFF(DAY,MIN(SOH.OrderDate),MAX(SOH.OrderDate)) AS DaysSinceFirstPurchase	, CASE		WHEN COUNT(SOH.SalesOrderID) > 1 THEN 'Return Customer'		ELSE 'New Customer'	  END AS CustomerTypeFROM Sales.Customer SCLEFT JOIN Sales.SalesOrderHeader SOHON SC.CustomerID = SOH.CustomerIDGROUP BY SC.CustomerID;