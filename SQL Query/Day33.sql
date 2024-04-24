-- Business scenario Q211 - Cost Analysis and Profitability of Product Models
WITH ProductModelAnalysis AS (
	SELECT *
	FROM Production.ProductModel PM
	LEFT JOIN Production.Product P
	ON PM.ProductModelID = P.ProductModelID
	LEFT JOIN Production.BillOfMaterials BM
	ON P.ProductID = BM.ProductAssemblyID
)
;