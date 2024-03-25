-- . Business scenario Q31 - Employee City Analysis
SELECT EmployeeID
	, City
FROM Employee.Employee
GROUP BY EmployeeID, City
;


-- Business scenario Q32 - Employee Salary Grouping
SELECT EmployeeID
	, SUM(Salary) AS TotalSalary
FROM Employee.Pay
GROUP BY Salary, EmployeeID
;


-- Business Scenario Q33 - Employee City Population Analysis
SELECT COUNT(EmployeeID) AS TotalEmployees
	, City
FROM Employee.Employee
GROUP BY City
;


-- Business scenario Q34  Employee City Population Analysis I (with Sorting)
SELECT COUNT(EmployeeID) AS TotalEmployees
	, City
FROM Employee.Employee
GROUP BY City
ORDER BY COUNT(EmployeeID) DESC
;


-- Business scenario Q35 - Employee City Population Analysis II
SELECT City
	, COUNT(EmployeeID) AS TotalEmployees
FROM Employee.Employee
GROUP BY City
ORDER BY 1,2
;


-- Business scenario Q36 - Employee Compensation Analysis and Salary Filtering for Payroll Management
SELECT EmployeeID
	, SUM(Salary + Bonus) AS TotalCompensation
FROM Employee.Pay
GROUP BY EmployeeID
HAVING SUM(Salary+Bonus) <= 3000
;


-- .Business scenario Q37 - City-wise Employee Population Analysis and Filtering I
SELECT City
	, COUNT(EmployeeID) AS TotalEmployees
FROM Employee.Employee
GROUP BY City
HAVING COUNT(EmployeeID) >= 3
ORDER BY COUNT(EmployeeID) DESC
;
-- OR
SELECT City
	, COUNT(EmployeeID) AS TotalEmployees
FROM Employee.Employee
GROUP BY City
HAVING COUNT(EmployeeID) >= 3
ORDER BY TotalEmployees DESC
;


-- Business scenario Q38 - City-wise Employee Population Analysis and Filtering IISELECT City
	, COUNT(EmployeeID) AS TotalEmployees
FROM Employee.Employee
GROUP BY City
HAVING COUNT(EmployeeID) <= 3
ORDER BY 2, 1 DESC
;-- Business scenario Q39 - Employee Full Name ConcatenationSELECT EmployeeID	, CONCAT(FirstName,' ',LastName) AS FullNameFROM Employee.Employee;-- Business scenario Q40 - Protecting Phone Number PrivacySELECT EmployeeID	, LastName	, FirstName	, TRANSLATE (Phone,'123456789','XXXXXXXXX') AS PhoneProteectedFROM Employee.Employee
;