-- Business scenario Q61 -- Employee Performance Evaluation
SELECT EE.EmployeeID
	, CONCAT(EE.FirstName,' ',EE.LastName) AS FullName
	, EE.EmployeeAddress
	, EE.Phone
	, EP.JobTitle
	, EP.HireDate
	, EP.Salary
	, EP.Bonus
	, (EP.Salary + EP.Bonus) AS TotalCompensation
FROM Employee.Employee EE
INNER JOIN Employee.Pay EP
ON EE.EmployeeID = EP.EmployeeID
;


-- Business scenario Q62 - Analysis of Employee Promotion Eligibility
SELECT EE.EmployeeID
	, CONCAT(EE.FirstName,' ',EE.LastName) AS FullName
	, EP.JobTitle 
FROM Employee.Employee EE
INNER JOIN Employee.Pay EP
ON EE.EmployeeID = EP.EmployeeID
WHERE (EP.JobTitle = 'Sales Support' OR EP.JobTitle = 'Salesman')
AND (DATEDIFF(YEAR,EP.HireDate,GETDATE()) >= 5)
;


-- Business scenario Q63 - Employee Bonus Eligibility
SELECT  EE.EmployeeID
	, CONCAT(EE.FirstName,' ',EE.LastName) AS FullName
	, EP.JobTitle
	, EP.Bonus
FROM Employee.Employee EE
INNER JOIN Employee.Pay EP
ON EE.EmployeeID = EP.EmployeeID
WHERE EP.JobTitle IN ('Salesman','Sales Support') 
AND EP.Bonus >= 1000
;


-- Business scenario Q64 - Employee Tenure and Salary Analysis
SELECT  EE.EmployeeID
	, CONCAT(EE.FirstName,' ',EE.LastName) AS FullName
	, EP.JobTitle
	, EP.Salary
	, DATEDIFF(YEAR,EP.HireDate,GETDATE()) AS Tenure
FROM Employee.Employee EE
INNER JOIN Employee.Pay EP
ON EE.EmployeeID = EP.EmployeeID
WHERE EP.JobTitle IN ('Salesman','Sales Support')
ORDER BY EP.JobTitle, EP.Salary
;


-- Business scenario Q65 - Customer Order Analysi
SELECT CO.OrderID
	, CP.ProductID
	, CP.ProductDescription
	, CP.Cost
	, CO.OrderQuantity
	, CO.OrderDate
	, CC.CustomerID
	, CC.CustomerName
	, CC.Address
	, CC.City
FROM CustomerTab.CustomerOrdersTabl CO
INNER JOIN CustomerTab.CustomerTabl CC
ON CC.CustomerID = CO.CustomerID
INNER JOIN CustomerTab.CustomerProductTabl CP
ON CO.ProductID = CP.ProductID
ORDER BY CO.OrderDate, CO.OrderQuantity
;


-- Business scenario Q66 - Customer Order Analysis with Missing Orders
SELECT CO.OrderID
	, CP.ProductID
	, CP.ProductDescription
	, CP.Cost
	, CO.OrderQuantity
	, CO.OrderDate
	, CC.CustomerID
	, CC.CustomerName
	, CC.Address
	, CC.City
FROM CustomerTab.CustomerTabl CC
LEFT JOIN CustomerTab.CustomerOrdersTabl CO
ON CC.CustomerID = CO.CustomerID
LEFT JOIN CustomerTab.CustomerProductTabl CP
ON CO.ProductID = CP.ProductID
ORDER BY CC.CustomerName, CO.OrderDate, CP.ProductDescription
;


-- Business scenario Q67 - Customer Order Analysis with Optional Customers
SELECT CO.OrderID
	, CP.ProductID
	, CP.ProductDescription
	, CP.Cost
	, CO.OrderQuantity
	, CO.OrderDate
	, CC.CustomerID
	, CC.CustomerName
	, CC.Address
	, CC.City
FROM CustomerTab.CustomerTabl CC
RIGHT JOIN CustomerTab.CustomerOrdersTabl CO
ON CC.CustomerID = CO.CustomerID
RIGHT JOIN CustomerTab.CustomerProductTabl CP
ON CO.ProductID = CP.ProductID
ORDER BY CC.CustomerName, CO.OrderDate, CP.ProductDescription
;


-- Business scenario Q68 - Customer-Order Relationship Analysis
SELECT CC.CustomerID
	, CC.CustomerName
	, CC.Address
	, CC.City
	, CO.OrderID
	, CO.ProductID
	, CO.OrderQuantity
	, CO.OrderDate
FROM CustomerTab.CustomerTabl CC
FULL JOIN CustomerTab.CustomerOrdersTabl CO
ON CC.CustomerID = CO.CustomerID
ORDER BY CC.CustomerName, CO.OrderDate
;


-- Business scenario Q69 - Employee Carpooling Analysis
SELECT E1.EmployeeID AS Employee1ID
	, E1.FirstName AS Employee1FirstName
	, E1.LastName AS Employee1LastName
	, E1.Phone AS Employee1Phone
	, E2.EmployeeID AS Employee2ID
	, E2.FirstName AS Employee2FirstName
	, E2.LastName AS Employee2LastName
	, E2.Phone AS Employee2Phone
	, E1.City AS CommonCity
FROM Employee.Employee E1
INNER JOIN Employee.Employee E2
ON E1.City = E2.City
AND E1.EmployeeID <> E2.EmployeeID
;


-- Business scenario Q70 - Product Analysis with Missing Order QuantitySELECT CO.ProductID	, CP.ProductDescription	, CP.Cost	, CO.OrderID	, CO.OrderQuantity	, CO.OrderDateFROM CustomerTab.CustomerOrdersTabl COLEFT OUTER JOIN CustomerTab.CustomerProductTabl CPON CO.ProductID = CP.ProductID;