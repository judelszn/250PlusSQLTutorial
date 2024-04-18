-- Business scenario Q186 - Stock Item Colour Analysis
USE WideWorldImporters;
SELECT C.ColorName
	, COUNT(S.StockItemID) AS ItemCount
FROM Warehouse.Colors C
LEFT JOIN Warehouse.StockItems S
ON C.ColorID = S.ColorID
GROUP BY C.ColorName
ORDER BY COUNT(S.StockItemID) DESC
;


-- Business scenario Q187 - Stock Item Colour Distribution Analysis
SELECT C.ColorName
	, COUNT(S.StockItemID) AS ItemCount
	, (COUNT(S.StockItemID)*100 /SUM(COUNT(S.StockItemID)) OVER()) AS Percentage
FROM Warehouse.Colors C
LEFT JOIN Warehouse.StockItems S
ON C.ColorID = S.ColorID
GROUP BY C.ColorName
ORDER BY COUNT(S.StockItemID) DESC
;


-- Business scenario Q188 - Average Purchase Order Line Quantity by Package Type
SELECT PT.PackageTypeName
	 , AVG(SI.QuantityPerOuter) AS AverageOrderLineQuantity
FROM Warehouse.PackageTypes PT
LEFT JOIN Warehouse.StockItems SI
ON PT.PackageTypeID = SI.UnitPackageID
LEFT JOIN Purchasing.PurchaseOrderLines OL
ON SI.StockItemID = OL.StockItemID
GROUP BY PT.PackageTypeName
ORDER BY AVG(SI.QuantityPerOuter) DESC
;


-- Business scenario Q189 - Package Quantity Comparison
SELECT PT.PackageTypeName
	, SUM(SI.QuantityPerOuter) AS PurchaseOrderQuantity
	, SUM(IL.Quantity) AS SalesInvoiceQuantity
FROM Warehouse.PackageTypes PT
LEFT JOIN Warehouse.StockItems SI
ON PT.PackageTypeID = SI.UnitPackageID
LEFT JOIN Purchasing.PurchaseOrderLines OL
ON SI.StockItemID = OL.StockItemID
LEFT JOIN Sales.InvoiceLines IL
ON SI.StockItemID = IL.StockItemID
GROUP BY PT.PackageTypeName
ORDER BY PT.PackageTypeName
;


-- Business scenario Q190 - Stock Group Analysis
SELECT SG.StockGroupName
	, SI.StockItemName
	, P.FullName AS PersonName
FROM Warehouse.StockItemStockGroups ISG
INNER JOIN Warehouse.StockGroups SG
ON ISG.StockGroupID = SG.StockGroupID
INNER JOIN Warehouse.StockItems SI
ON ISG.StockItemID = SI.StockItemID
LEFT JOIN Application.People P
ON SG.StockGroupID = P.PersonID
ORDER BY SG.StockGroupName, SI.StockItemName
;