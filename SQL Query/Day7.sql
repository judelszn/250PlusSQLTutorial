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