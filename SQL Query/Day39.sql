-- Business scenario Q241. - Optimising Medication Prescriptions in Healthcare 
USE HealthCare;
SELECT M.MedicationID
	, M.MedicationName
	, M.Dosage
	, M.PatientID
	, M.PrescribingDoctorID
	, M.PrescriptionDate
	, M.ExpiryDate
	, P.FirstName AS PatientFirstName
	, P.LastName AS PatientLastName
	, D.FirstName AS DoctorFirstName
	, D.LastName AS DoctorLastName
FROM Medical.Medications M
INNER JOIN Medical.Patients P
ON M.PatientID = P.PatientID
INNER JOIN Medical.Doctors D
ON M.PrescribingDoctorID = D.DoctorID
WHERE M.ExpiryDate <= DATEADD(MONTH, 6, GETDATE()) OR M.ExpiryDate <= GETDATE()
;

SELECT D.DoctorID
	, D.FirstName
	, D.LastName
	, M.MedicationName
	, P.FirstName AS PatientFirstName
	, P.LastName AS PatientLastName
FROM Medical.Medications M
INNER JOIN Medical.Patients P
ON M.PatientID = P.PatientID
INNER JOIN Medical.Doctors D
ON M.PrescribingDoctorID = D.DoctorID
WHERE EXISTS (
	SELECT 1
	FROM Medical.Medications MM
	WHERE MM.PatientID = M.PatientID 
		AND MM.MedicationID <> M.MedicationID
		AND MM.ExpiryDate >= GETDATE()
		AND MM.MedicationName = M.MedicationName
)
;


-- Business scenario Q242 - Doctor Appointment Utilisation AnalysisWITH DoctorAvailability AS (	SELECT D.DoctorID		, D.FirstName AS DoctorFirstName		, D.LastName AS DoctorLastName		, COUNT(A.AppointmentID) AS NumberOfAppointments	FROM Medical.Doctors D	LEFT JOIN Medical.Appointments A ON D.DoctorID =A.DoctorID	GROUP BY D.DoctorID, D.FirstName, D.LastName)SELECT DA.DoctorFirstName	, DA.DoctorLastName	, DA.NumberOfAppointments AS TotalAppointments	, MAX(A.AppointmentDateTime) AS LastAppointmentDate	, DATEDIFF(DAY, MAX(A.AppointmentDateTime), GETDATE()) AS DaysSinceLastAppointmentFROM DoctorAvailability DALEFT JOIN Medical.Appointments A ON DA.DoctorID = A.DoctorIDGROUP BY DA.DoctorID, DA.DoctorFirstName, DA.DoctorLastName, DA.NumberOfAppointmentsORDER BY DATEDIFF(DAY, MAX(A.AppointmentDateTime), GETDATE()) DESC;-- Business scenario Q243 - Customer Loyalty Analysis (Simplified)USE AdventureWorksDW2022;SELECT C.CustomerKey	, C.FirstName	, C.LastName	, C.EmailAddress	, CASE		WHEN DATEDIFF(YEAR, C.BirthDate, GETDATE()) >= 18 THEN 'Adult'		ELSE 'Minor'	  END AS CustomerGroup	, CASE		WHEN PC.TotalPurchase >= 10 THEN 'Loyal'		ELSE 'Regular'	  END AS CustomerLoyaltyStatusFROM DimCustomer CLEFT JOIN (	SELECT FS.CustomerKey		, COUNT(DISTINCT FS.SalesOrderNumber) AS TotalPurchase	FROM FactInternetSales FS	GROUP BY FS.CustomerKey	) PCON C.CustomerKey = PC.CustomerKeyORDER BY C.CustomerKey;-- Business scenario Q244 - Customer Sales AnalysisWITH CustomerSales AS (	SELECT C.FirstName		, C.LastName		, SUM(FS.SalesAmount) AS TotalSalesAmount	FROM dbo.FactInternetSales FS	INNER JOIN dbo.DimCustomer C ON FS.CustomerKey = C.CustomerKey	GROUP BY C.FirstName, C.LastName)SELECT CS.FirstName	, CS.LastName	, CS.TotalSalesAmount	, CASE		WHEN CS.TotalSalesAmount >= 5000 THEN 'High-Spending'		WHEN CS.TotalSalesAmount >= 2000 THEN 'Medium-Spending'		ELSE 'Low-Spending'	  END AS CustomerCategory	FROM CustomerSales CSORDER BY CS.TotalSalesAmount;-- Business scenario Q245 - Product Inventory AnalysisWITH ProductInventory AS (	SELECT P.EnglishProductName AS ProductName		, SUM(I.UnitsBalance) AS TotalQuantity	FROM dbo.FactProductInventory I	INNER JOIN dbo.DimProduct P ON I.ProductKey = P.ProductKey	GROUP BY P.EnglishProductName)SELECT PT.ProductName	, PT.TotalQuantity	, CASE		WHEN PT.TotalQuantity < 50 THEN 'Low Inventory'		WHEN PT.TotalQuantity < 100 THEN 'Moderate Inventory'		ELSE 'Sufficient Inventory'	  END AS InventoryStatusFROM ProductInventory PTORDER BY PT.TotalQuantity DESC;