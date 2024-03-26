-- Business scenario Q41 - Name Uppercase Conversion
SELECT EmployeeID
	, UPPER(FirstName) AS UpperFirstName
	, UPPER(LastName) AS UpperLastName
	, City
	, PostCode
FROM Employee.Employee
;


-- Business scenario Q42 - Phone Number Extraction
SELECT EmployeeID
	, FirstName
	, LastName 
	, City
	, PostCode
	, SUBSTRING(Phone,6, 4) AS Phone
FROM Employee.Employee
;


-- Business scenario Q43 - Address Cleanup
SELECT EmployeeID
	, FirstName
	, LastName
	, LTRIM(RTRIM(EmployeeAddress)) AS EmployeeAdd
FROM Employee.Employee
;


-- Business scenario Q44 - Name Length Calculation
SELECT EmployeeID
	, LEN(FirstName) FirstNameLength
	, LEN(LastName) LastNameLength
FROM Employee.Employee
;


-- Business scenario Q45 - Employee Compensation Calculation
SELECT EmployeeID
	, JobTitle
	, HireDate
	, COALESCE(HourlyRate,0) + COALESCE(Salary,0) + COALESCE(Bonus,0) AS TotalCompensation
FROM Employee.Pay
;


-- Business scenario Q46 - Phone Number Formatting
SELECT EmployeeID
	, FirstName
	, LastName
	, RIGHT(Phone + REPLICATE('-',15),15) AS FormattedPhone
FROM Employee.Employee
;


-- Business scenario Q47 - Product Description Formatting
SELECT ProductID
	, LEFT(REPLICATE('.',30) + ProductDescription, 30) AS FormattedProductDescription
	, Cost
FROM CustomerTab.CustomerProductTabl
;


-- Business scenario Q48 - Price Conversion
SELECT ProductID
	 , ProductDescription
	 , CAST (Cost AS DECIMAL (10,2)) AS Price
FROM CustomerTab.CustomerProductTabl
;
-- OR
SELECT ProductID
	 , ProductDescription
	 , CONVERT(DECIMAL(10,2), Cost) AS Price
FROM CustomerTab.CustomerProductTabl
;


-- Business scenario Q49 - Employee Data Transformation for Reporting
SELECT EmployeeID
	, CONCAT(FirstName,' ', LastName) AS FullName
	, CONCAT(SUBSTRING(Phone,1,3),'-',SUBSTRING(Phone,4,3),'-',SUBSTRING(Phone,7,4)) AS PhoneF
FROM Employee.Employee
;


-- Business scenario Q50 - Years of Service CalculationSELECT EmployeeID	, JobTitle	, HireDate	, LastDate	, DATEDIFF(YEAR,HireDate,LastDate) AS YearsOfServiceFROM Employee.PayWHERE DATEDIFF(YEAR,HireDate,LastDate) >= 7		AND YEAR(HireDate) BETWEEN 2001 AND 2009		AND YEAR(LastDate) BETWEEN 2011 AND 2012;