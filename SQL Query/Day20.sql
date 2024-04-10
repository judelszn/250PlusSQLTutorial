-- Business scenario Q146 - Document Usage Analysis
SELECT PD.DocumentNode
	, PD.Title AS DocumentTitle
	, COUNT(PPD.ProductID) AS AssociatedProductCount
FROM Production.Document PD
LEFT JOIN Production.ProductDocument PPD
ON PD.DocumentNode = PPD.DocumentNode
GROUP BY PD.DocumentNode, PD.Title
ORDER BY COUNT(PPD.ProductID) DESC, PD.DocumentNode
;