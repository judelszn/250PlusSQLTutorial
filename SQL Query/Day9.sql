-- Business scenario Q81 - Combining Product and Customer Data for Marketing in a Specific City
SELECT CP.ProductID
	, CP.ProductDescription AS ProductName
	, NULL AS ProductAddress
FROM CustomerTab.CustomerProductTabl CP
UNION
SELECT CC.CustomerID
	, CC.CustomerName
	, CC.City AS Location
FROM CustomerTab.CustomerTabl CC
;


-- Business scenario Q82 - Identify Customers Who Have Not Ordered
SELECT CC.CustomerID
	, CC.CustomerName
	, CC.Address
FROM CustomerTab.CustomerTabl CC
EXCEPT
SELECT CC.CustomerID
	, CC.CustomerName
	, CC.Address
FROM CustomerTab.CustomerTabl CC
INNER JOIN CustomerTab.CustomerOrdersTabl CO
ON CC.CustomerID = CO.CustomerID
;


-- Business scenario Q83 - Identifying Unordered ProductsSELECT CP.ProductID	, CP.ProductDescription	, CP.CostFROM CustomerTab.CustomerProductTabl CPEXCEPTSELECT CP.ProductID	, CP.ProductDescription	, CP.CostFROM CustomerTab.CustomerProductTabl CPINNER JOIN CustomerTab.CustomerOrdersTabl COON CP.ProductID = CO.ProductID;-- Business scenario Q84 - Payroll Expense AnalysisSELECT EmployeeID	, JobTitle	, SUM(Salary) AS TotalSalaryFROM Employee.PayGROUP BY ROLLUP (JobTitle,EmployeeID);-- Business scenario Q85 - Analysis of customer purchase behaviourSELECT CustomerID	, ProductID	, COUNT(OrderID) AS CountOrders	, SUM(OrderQuantity) AS TotalOrdersFROM CustomerTab.CustomerOrdersTablGROUP BY ROLLUP (CustomerID, ProductID);-- Business scenario Q86 - Analyse Customer Purchase Behaviour by MonthSELECT CustomerID	, ProductID	,MONTH(OrderDate) AS OrderMonth	, COUNT(OrderID) AS TotalOrders	, SUM(OrderQuantity) AS TotalQuantityFROM CustomerTab.CustomerOrdersTablGROUP BY CustomerID, ProductID, MONTH(OrderDate)WITH ROLLUP;-- Business scenario Q87 - Analyse Employee Salaries by Job TitleSELECT JobTitle	, SUM(Salary) AS TotalSalaryFROM Employee.PayGROUP BY JobTitleWITH ROLLUP;-- Business scenario Q88 - Compensation and HR AnalyticsSELECT EP.JobTitle	, EE.City	, YEAR(HireDate) AS HireYear	, SUM(Salary) AS TotalCompensationExpensesFROM Employee.Pay EPINNER JOIN Employee.Employee EEON EP.EmployeeID = EP.EmployeeIDGROUP BY CUBE(JobTitle,City,YEAR(HireDate))ORDER BY JobTitle,City, YEAR(HireDate);-- Business scenario Q89 - Sales and Market ExpansionSELECT CP.ProductID	, CC.City	, YEAR(CO.OrderDate) AS YearOrder	, SUM(CO.OrderQuantity * CP.Cost) AS TotalRevenueFROM CustomerTab.CustomerOrdersTabl COINNER JOIN CustomerTab.CustomerTabl CCON CO.CustomerID = CC.CustomerIDINNER JOIN CustomerTab.CustomerProductTabl CPON CO.ProductID = CP.ProductIDGROUP BY CUBE(CP.ProductID,CC.City,YEAR(CO.OrderDate))ORDER BY CP.ProductID, CC.City, YEAR(CO.OrderDate);-- Business scenario Q90 - Customer Loyalty Program AnalysisSELECT CO.CustomerID	, CASE		WHEN SUM(CO.OrderQuantity * CP.Cost) > 500 THEN 'Loyal Customer'		ELSE 'Regular Customer'		END AS CustomerStatus	, SUM(CO.OrderQuantity * CP.Cost) AS TotalAmountSpentFROM CustomerTab.CustomerOrdersTabl COINNER JOIN CustomerTab.CustomerProductTabl CPON CO.ProductID = CP.ProductIDGROUP BY CO.CustomerIDHAVING SUM(CO.OrderQuantity * CP.Cost) > 200;