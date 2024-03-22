-- Business scenario Q1 - Product Cost Distribution Analysis
SELECT *
FROM CustomerTab.CustomerProductTabl;


-- Business scenario Q2 - Product Quantity Analysis I
SELECT DISTINCT ProductID
FROM CustomerTab.CustomerOrdersTabl;

-- Business scenario Q3 - Product Quantity Analysis II
SELECT ALL ProductID
FROM CustomerTab.CustomerOrdersTabl;

-- Business Scenario Q4 - Price Range Analysis
SELECT ProductID -- a
	, ProductDescription
	, Cost
FROM CustomerTab.CustomerProductTabl
WHERE Cost < 1;

SELECT * -- b
FROM CustomerTab.CustomerProductTabl
WHERE Cost BETWEEN 2 AND 5;

SELECT * -- c
FROM CustomerTab.CustomerProductTabl
WHERE Cost > 6;


-- Business Scenario Q5 - Custom Product Selection
SELECT *
FROM CustomerTab.CustomerProductTabl
WHERE ProductID IN (2,567,89);


-- Business Scenario Q6 - Product Search by exact Name
SELECT *
FROM CustomerTab.CustomerProductTabl
WHERE ProductDescription = 'Instant Camera' 
OR ProductDescription = 'Phone Stand';


-- Business scenario Q7 - Items orders
SELECT *
FROM CustomerTab.CustomerOrdersTabl
WHERE NOT OrderQuantity = 5
;


-- Business scenario Q8 - Product Search by Description
SELECT *
FROM CustomerTab.CustomerProductTabl
WHERE ProductDescription LIKE '%Set%';


-- Business scenario Q9 - Order Tracking I
SELECT JobTitle
	, EmployeeID
FROM Employee.Pay
WHERE Salary IS NULL;


-- Business scenario Q10 - Order Tracking II
SELECT JobTitle
	, EmployeeID
FROM Employee.Pay
WHERE Salary IS NOT NULL;