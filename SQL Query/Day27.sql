-- Business scenario Q181 - Customer Location Analysis
USE WideWorldImporters
SELECT SP.StateProvinceName
	, COUNT(SC.CustomerID) AS CustomerCount
FROM Application.StateProvinces SP
LEFT JOIN Application.Cities C
ON SP.StateProvinceID = C.StateProvinceID
LEFT JOIN Sales.Customers SC
ON C.CityID = SC.DeliveryCityID
GROUP BY SP.StateProvinceName
ORDER BY COUNT(SC.CustomerID) DESC 
;


-- Business scenario Q182 - Delivery Method Contact List
SELECT DM.DeliveryMethodName
	, P.FullName AS ContactName 
	, P.EmailAddress
FROM Application.DeliveryMethods DM
INNER JOIN Application.People P
on DM.DeliveryMethodID = P.PersonID
ORDER BY DM.DeliveryMethodName
;


--  Business scenario Q183 - Supplier Performance AnalysisSELECT S.SupplierID	, S.SupplierName	, COUNT(DISTINCT PO.PurchaseOrderID) AS TotalPurchaseOrders	, COUNT(DISTINCT I.InvoiceID) AS TotalInvoicesFROM Purchasing.Suppliers SLEFT JOIN Purchasing.PurchaseOrders POON S.SupplierID = PO.SupplierIDLEFT JOIN Sales.Invoices ION S.DeliveryMethodID = I.DeliveryMethodIDGROUP BY S.SupplierID, S.SupplierNameORDER BY S.SupplierName;-- Business scenario Q184 - Transaction Analysis by Payment MethodSELECT PM.PaymentMethodName	, SUM(CASE WHEN ST.SupplierTransactionID IS NOT NULL THEN 1 ELSE 0 END)	AS SupplierTransactionCount	, SUM(CASE WHEN CT.CustomerTransactionID IS NOT NULL THEN 1 ELSE 0 END)	AS CustomerTransactionCountFROM Application.PaymentMethods PMLEFT JOIN Purchasing.SupplierTransactions STON PM.PaymentMethodID = ST.PaymentMethodIDLEFT JOIN Sales.CustomerTransactions CTON PM.PaymentMethodID = CT.PaymentMethodIDGROUP BY PM.PaymentMethodName;-- Business scenario Q185 - Payment Trends AnalysisSELECT PM.PaymentMethodName	, YEAR(ST.TransactionDate) AS TransactionYear	, SUM(CASE WHEN ST.SupplierTransactionID IS NOT NULL THEN 1 ELSE 0 END)	AS SupplierTransactionCount	, SUM(CASE WHEN CT.CustomerTransactionID IS NOT NULL THEN 1 ELSE 0 END)	AS CustomerTransactionCountFROM Application.PaymentMethods PMLEFT JOIN Purchasing.SupplierTransactions STON PM.PaymentMethodID = ST.PaymentMethodIDLEFT JOIN Sales.CustomerTransactions CTON PM.PaymentMethodID = CT.PaymentMethodIDGROUP BY PM.PaymentMethodName, YEAR(ST.TransactionDate)ORDER BY YEAR(ST.TransactionDate), SupplierTransactionCount DESC, CustomerTransactionCount DESC;