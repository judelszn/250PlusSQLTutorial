-- Business scenario Q136 - Analysing Customer Locations for Sales OptimisationSELECT PA.City	, SUM(SOH.TotalDue) AS TotalSalesAmountFROM Person.Address PAINNER JOIN Person.BusinessEntityAddress BEAON PA.AddressID = BEA.AddressIDINNER JOIN Sales.SalesOrderHeader SOHON BEA.BusinessEntityID = SOH.CustomerIDGROUP BY PA.CityORDER BY SUM(SOH.TotalDue) DESC;-- Business scenario Q137 - Customer Geographical Analysis for Sales ExpansionSELECT PA.City	, COUNT(DISTINCT SOH.CustomerID) AS TotalCustomers	, AVG(SOH.TotalDue) AS AverageOrderValueFROM Person.Address PAINNER JOIN Person.BusinessEntityAddress BAON PA.AddressID = BA.AddressIDINNER JOIN Sales.SalesOrderHeader SOHON BA.BusinessEntityID = SOH.CustomerIDGROUP BY PA.CityORDER BY COUNT(DISTINCT SOH.CustomerID) DESC;-- Business scenario Q138 - Order Analysis for Customer SegmentationSELECT CASE		WHEN SOH.TotalDue > 5000 THEN 'High-Value Customer'		WHEN SOH.TotalDue BETWEEN 1000 AND 5000 THEN 'Regular Customer'		ELSE 'Ocasional Customer'	   END AS CustomerSegmemt	, COUNT(*) AS CustomerCountFROM Sales.SalesOrderHeader SOHGROUP BY CASE		WHEN SOH.TotalDue > 5000 THEN 'High-Value Customer'		WHEN SOH.TotalDue BETWEEN 1000 AND 5000 THEN 'Regular Customer'		ELSE 'Ocasional Customer'	   END ;-- Business scenario Q139 - Vendor and Store AnalysisSELECT TOP 5 PV.BusinessEntityID AS VenderID	, COUNT(DISTINCT PP.ProductID) AS ProductCountFROM Purchasing.ProductVendor PPVINNER JOIN Purchasing.Vendor PVON PPV.BusinessEntityID = PV.BusinessEntityIDINNER JOIN Production.Product PPON PPV.ProductID = PP.ProductIDGROUP BY PV.BusinessEntityIDORDER BY COUNT(DISTINCT PP.ProductID);SELECT TOP 1 SS.Name AS StoreName
	, COUNT(DISTINCT PV.BusinessEntityID) AS VendorCount
FROM Sales.Customer SC
JOIN Sales.Store SS
ON SC.StoreID = SS.BusinessEntityID
JOIN Purchasing.Vendor PV  
ON SC.StoreID = PV.BusinessEntityID
GROUP BY SS.Name
ORDER BY COUNT(DISTINCT PV.BusinessEntityID) DESC;SELECT AVG(VendorCount) AS AvgVendorRelationshipsPerStore
FROM ( SELECT SC.StoreID,
		COUNT(DISTINCT PV.BusinessEntityID) AS VendorCount
		FROM Sales.Customer SC
		JOIN Purchasing.Vendor PV 
		ON SC.StoreID = PV.BusinessEntityID
		GROUP BY SC.StoreID
	) AS Subquery
;


-- Business scenario Q140 - Currency and Sales Territory Analysis
SELECT DISTINCT CR.CountryRegionCode
	, CR.Name AS CountryRegion
	, SP.StateProvinceCode
	, SP.Name AS StateProvince
FROM Person.CountryRegion CR
JOIN Person.StateProvince SP 
ON CR.CountryRegionCode = SP.CountryRegionCode
ORDER BY CR.CountryRegionCode, SP.StateProvinceCode
;

SELECT CR.CountryRegionCode
	, CR.Name AS CountryRegion
	, ST.TerritoryID
	, ST.Name AS SalesTerritory
	, CRC.CurrencyCode
FROM Sales.CountryRegionCurrency CRC
JOIN Person.CountryRegion CR
ON CRC.CountryRegionCode = CR.CountryRegionCode
JOIN Sales.SalesTerritory ST 
ON CR.CountryRegionCode = ST.CountryRegionCode
ORDER BY CR.CountryRegionCode, CRC.CurrencyCode
;