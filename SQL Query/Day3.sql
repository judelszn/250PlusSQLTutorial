-- . Business scenario Q21 - Affordable Products with Reverse Alphabetical Order
SELECT *
FROM CustomerTab.CustomerProductTabl
WHERE Cost < 5
ORDER BY ProductDescription DESC
;


-- Business scenario Q22 - Employee Performance Ranking
SELECT EmployeeID
	, JobTitle
	, Salary
FROM Employee.Pay
ORDER BY JobTitle ASC, Salary DESC
;


-- Business scenario Q23 - High-Salary Employees in Specific Roles
SELECT EmployeeID
	, JobTitle
	, HireDate
	, Salary
FROM Employee.Pay
WHERE JobTitle IN ('Salesman', 'Shipper')
ORDER BY JobTitle ASC, Salary ASC
;


-- Business scenario Q24 - Balanced Product Display
SELECT *
FROM CustomerTab.CustomerProductTabl
ORDER BY ProductDescription ASC, Cost ASC
;


-- Business scenario Q25 - Product Inventory Reorder
SELECT *
FROM CustomerTab.CustomerProductTabl
ORDER BY ProductDescription DESC, Cost ASC
;


-- Business scenario Q26 - Employee Payroll AnalysisSELECT COUNT(EmployeeID) AS TotalEmployees -- aFROM Employee.Pay;SELECT COUNT(DISTINCT JobTitle) AS DistinctJobTitles -- bFROM Employee.Pay;SELECT COUNT(Salary) AS RecordOfSalary -- cFROM Employee.Pay;SELECT COUNT(*) AS NumberOfRows -- dFROM Employee.Pay;-- Business scenario Q27 - Total Salary CalculationSELECT SUM(Salary) AS TotalSalaryFROM Employee.Pay;-- Business scenario Q28 - Average Salary CalculationSELECT AVG(Salary) AS AverageSalry	, SUM(Salary) AS TotalSalaryFROM Employee.Pay;-- Business scenario Q29 - Salary AnalysisSELECT MIN(Salary) AS MinimumSalary -- aFROM Employee.Pay;SELECT MAX(Salary) AS MaximumSalary -- bFROM Employee.Pay;-- Business scenario Q30 - Total Compensation CalculationSELECT (Salary + Bonus) AS TotalCompensationFROM Employee.Pay;SELECT AVG(Salary + Bonus) AS AverageTotalCompensationFROM Employee.Pay;