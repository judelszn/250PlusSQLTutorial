-- Business scenario Q126 - Retirement Age Analysis
DECLARE @RetirementAge INT = 65

SELECT HRE.BusinessEntityID
	, HRE.HireDate
	, DATEDIFF(YEAR,HRE.HireDate,GETDATE()) AS YearsWorked
	, CASE
		WHEN (DATEDIFF(YEAR,HRE.HireDate,GETDATE()) + @RetirementAge) >= @RetirementAge THEN 0
		ELSE @RetirementAge - (DATEDIFF(YEAR,HRE.HireDate,GETDATE()) + @RetirementAge)
	  END AS YearsToRetire
FROM HumanResources.Employee HRE
;


-- Business scenario Q127 - Employee Productivity Ranking