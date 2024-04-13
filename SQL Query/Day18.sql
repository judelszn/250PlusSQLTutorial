-- Business scenario Q136 - Analysing Customer Locations for Sales Optimisation
	, COUNT(DISTINCT PV.BusinessEntityID) AS VendorCount
FROM Sales.Customer SC
JOIN Sales.Store SS
ON SC.StoreID = SS.BusinessEntityID
JOIN Purchasing.Vendor PV  
ON SC.StoreID = PV.BusinessEntityID
GROUP BY SS.Name
ORDER BY COUNT(DISTINCT PV.BusinessEntityID) DESC
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