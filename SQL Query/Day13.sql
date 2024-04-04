-- Business scenario Q111 - Supplier Performance Evaluation: Average Cost Performance Analysis
SELECT PPV.BusinessEntityID
	, PV.Name VendorName
	, AVG((POD.UnitPrice - PPV.StandardPrice) * POD.OrderQty) AS AverageCostPerformance
FROM Purchasing.ProductVendor PPV
INNER JOIN Purchasing.PurchaseOrderDetail POD
ON PPV.ProductID = POD.ProductID
INNER JOIN Purchasing.PurchaseOrderHeader POH
ON POD.PurchaseOrderID = POH.VendorID
INNER JOIN Purchasing.Vendor PV
ON PPV.BusinessEntityID = PV.BusinessEntityID
GROUP BY PPV.BusinessEntityID, PV.Name
;


-- Business scenario Q112 
SELECT SUM(TotalDue) AS TotalSalesRevenue
FROM Sales.SalesOrderHeader
;


-- Business scenario Q113
SELECT SUM(TotalDue) AS TotalExpenses
FROM Purchasing.PurchaseOrderHeader
;


-- Business scenario Q114
SELECT SUM(SOH.TotalDue) - SUM(POD.TotalDue) AS NetIncome
FROM Sales.SalesOrderHeader SOH
INNER JOIN Purchasing.PurchaseOrderHeader POD
ON SOH.SalesOrderID = POD.PurchaseOrderID
;
-- OR
SELECT TotalSalesRevenue - TotalExpenses AS NetIncome
FROM (
		SELECT (SELECT SUM(TotalDue) AS TotalSalesRevenue
				FROM Sales.SalesOrderHeader
			) AS TotalSalesRevenue
			, (SELECT SUM(TotalDue) AS TotalExpenses
				FROM Purchasing.PurchaseOrderHeader
			) AS TotalExpenses
		) FinancialData
;


-- Business scenario Q115
SELECT SUM(TotalDue) AS TotalActualExpenses
FROM Purchasing.PurchaseOrderHeader
;