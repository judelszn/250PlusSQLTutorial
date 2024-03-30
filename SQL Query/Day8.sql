-- Business scenario Q71 - Total Compensation Report for HR Analysis: Salary and Bonus
SELECT EE.EmployeeID
	, CONCAT(EE.FirstName,' ',EE.LastName)
	, EE.EmployeeAddress
	, EE.Phone
	, EP.JobTitle
	, (EP.Salary + EP.Bonus) AS TotalCompensation
FROM Employee.Employee EE
CROSS JOIN Employee.Pay EP
ORDER BY EE.EmployeeID
;


-- 72.Business scenario Q72 - Identifying Employees with Highest Bonuses
SELECT EE.EmployeeAddress
	, CONCAT(EE.FirstName,' ', EE.LastName) AS FullName
	, EP.Bonus
FROM Employee.Employee EE
INNER JOIN Employee.Pay EP
ON EE.EmployeeID = EP.EmployeeID
WHERE EP.Bonus IN (SELECT TOP 5 EP.Bonus
					FROM Employee.Pay EP
)
ORDER BY EP.Bonus DESC
;


-- .Business scenario Q73 - Identifying Customers with High Total Order Quantities
SELECT CC.CustomerID
	, CC.CustomerName
	,CO.OrderID
	, CO.ProductID
	, CO.OrderDate
	, CO.OrderQuantity
FROM CustomerTab.CustomerTabl CC
INNER JOIN CustomerTab.CustomerOrdersTabl CO
ON CC.CustomerID = CO.CustomerID
WHERE CO.OrderQuantity IN (SELECT CO.OrderQuantity
							FROM CustomerTab.CustomerOrdersTabl CO
							WHERE CO.OrderQuantity > 25
)
ORDER BY CO.OrderQuantity DESC
;
-- OR
SELECT CustomerName
FROM CustomerTab.CustomerTabl
WHERE CustomerID IN (
SELECT CustomerID
FROM CustomerTab.CustomerOrdersTabl
GROUP BY CustomerID
HAVING SUM(OrderQuantity) > 25
);


-- Business scenario Q74 - Customer Order Analysis: Total Product Cost and Top Spender
SELECT CustomerID
	, SUM(OrderTotal) AS TotalSpent
FROM (SELECT CO.CustomerID
			, (CP.Cost * CO.OrderQuantity) AS OrderTotal
		FROM CustomerTab.CustomerOrdersTabl CO
		INNER JOIN CustomerTab.CustomerProductTabl CP 
		ON CO.ProductID = CP.ProductID
) AS CustomerOrders
GROUP BY CustomerID
ORDER BY TotalSpent
;


-- Business scenario Q75 - Identifying Unordered Products: Customer and Product Analysis
SELECT CP.ProductID
	, CP.ProductDescription
FROM CustomerTab.CustomerProductTabl CP
LEFT JOIN (SELECT DISTINCT CO.ProductID
			FROM CustomerTab.CustomerOrdersTabl CO
			) AS OrderedProducts
ON CP.ProductID = OrderedProducts.ProductID
WHERE OrderedProducts.ProductID IS NULL
;


-- Business scenario Q76 - Customer Average Order Cost Analysis with Threshold
SELECT CustomerID
	, AVG(OrderTotal) AS AverageOrderCost
FROM (SELECT CO.CustomerID
		, (CP.Cost * CO.OrderQuantity) AS OrderTotal
		FROM CustomerTab.CustomerOrdersTabl CO
		INNER JOIN CustomerTab.CustomerProductTabl CP
		ON CO.ProductID = CP.ProductID
		) AS CustomerOrders
GROUP BY CustomerID
HAVING AVG(OrderTotal) > 50
;


-- Business scenario Q77 - Average Salary Analysis for Employees
SELECT AVG(EP.Salary) AS AverageSalary
	, COUNT(*) AS EmployeeCount
FROM Employee.Pay AS EP
WHERE YEAR(EP.HireDate) = (SELECT YEAR(HireDate)
							FROM Employee.Pay
							WHERE Salary = (SELECT MAX(Salary)
											FROM Employee.Pay
											)
							)
;


-- .Business scenario Q78 - Promotion Eligibility Analysis
SELECT EE.EmployeeID
	, CONCAT(EE.FirstName,' ',EE.LastName) AS FullName
FROM Employee.Employee EE
INNER JOIN Employee.Pay EP
ON EE.EmployeeID = EP.EmployeeID
WHERE EP.HireDate <= DATEADD(YEAR,-5,GETDATE())
AND EP.Salary < (SELECT AVG(EP2.Salary)
					FROM Employee.Pay EP2
					WHERE EP2.JobTitle = EP.JobTitle
				)
;


-- Business scenario Q79 - Identifying High-Value Customers
SELECT CC.CustomerName
	, CC.Address
FROM CustomerTab.CustomerTabl CC
WHERE CC.CustomerID IN (SELECT TOP 10 CO.CustomerID
					FROM CustomerTab.CustomerOrdersTabl CO
					GROUP BY CO.CustomerID
					ORDER BY SUM(CO.OrderQuantity) DESC
					)
;


-- Business scenario Q80 - Analyse top selling products
SELECT ProductID
	, ProductDescription
	, Cost
	, 'Top-Selling' AS SalesCategory
FROM CustomerTab.CustomerProductTabl
WHERE ProductID IN (SELECT TOP 5 ProductID
					FROM CustomerTab.CustomerProductTabl
					ORDER BY Cost DESC
					)
UNION
SELECT ProductID
	, ProductDescription
	, Cost
	, 'Least-Selling' AS SalesCategory
FROM CustomerTab.CustomerProductTabl
WHERE ProductID IN (SELECT TOP 5 ProductID
					FROM CustomerTab.CustomerProductTabl
					ORDER BY Cost ASC
					)
;