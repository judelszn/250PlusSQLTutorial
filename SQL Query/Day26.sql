-- Business scenario- Q176 - Doctor-Patient Appointment Analysis
USE HealthCare;
SELECT D.FirstName AS DoctorFirstName
	, D.LastName AS DoctorLastName
	, COUNT(A.AppointmentID) AS AppointmentCount
	, DATEPART(WEEKDAY,A.AppointmentDateTime) AS DayWeek
FROM Medical.Appointments A
INNER JOIN Medical.Doctors D
ON A.DoctorID = D.DoctorID
GROUP BY D.FirstName, D.LastName, DATEPART(WEEKDAY,A.AppointmentDateTime)
ORDER BY D.LastName, DATEPART(WEEKDAY,A.AppointmentDateTime)
;


-- Business scenario Q177 - Sales Representative Performance Analysis for a Specific Year
USE AdventureWorksDW2022;
DECLARE @AnalysisYear INT = 2012;
SELECT CONCAT(DE.FirstName,' ', DE.LastName) AS SalesPersonName
	, SUM(FRS.SalesAmount) AS TotalSalesAmount
FROM dbo.FactResellerSales FRS
INNER JOIN dbo.DimEmployee DE
ON FRS.EmployeeKey = DE.EmployeeKey
WHERE DATEPART(YEAR,FRS.OrderDate) = @AnalysisYear
GROUP BY DE.FirstName, DE.LastName
ORDER BY SUM(FRS.SalesAmount)
;


-- Business scenario Q178 - Yearly Sales Performance Analysis
SELECT DATEPART(YEAR,FIS.OrderDate) AS SalesYear
	, SUM(FIS.SalesAmount) AS TotalSalesAmount
FROM dbo.FactInternetSales FIS
GROUP BY DATEPART(YEAR,FIS.OrderDate)
ORDER BY DATEPART(YEAR,FIS.OrderDate)
;


-- Business scenario Q179 - Customer Sales Analysis
SELECT DC.CustomerKey
	, CONCAT(DC.FirstName,' ', DC.LastName) AS SalesPersonName
	, SUM(FIS.SalesAmount) AS TotalSalesAmount
FROM dbo.FactInternetSales FIS
INNER JOIN dbo.DimCustomer DC
ON FIS.CustomerKey = DC.CustomerKey
GROUP BY DC.CustomerKey, DC.FirstName, DC.LastName
ORDER BY SUM(FIS.SalesAmount) DESC
;


-- Business scenario Q180 - Sales Representative Assignment
USE WideWorldImporters;
SELECT AC.CityName
	, COUNT(SC.CustomerID) AS CustomerCount
FROM Application.Cities AC
LEFT JOIN Sales.Customers SC
ON AC.CityID = SC.DeliveryCityID
GROUP BY AC.CityName
ORDER BY COUNT(SC.CustomerID) DESC
;