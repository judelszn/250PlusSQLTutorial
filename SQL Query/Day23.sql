-- Business scenario Q161 - Account Branch Analysis
USE [Finance and Banking]
SELECT B.BranchID
	, B.BranchName
	, B.Location
	, COUNT(AB.AccountID) AS AccountCount
FROM Finance.UniqueBranches B
LEFT JOIN Finance.UniqueAccountBranches AB
ON B.BranchID = AB.BranchID
GROUP BY B.BranchID, B.BranchName, B.Location
ORDER BY COUNT(AB.AccountID) DESC
;


-- Business scenario Q162 - Branch-wise Account Balance SummarySELECT B.BranchName	, B.Location	, B.City	, SUM(A.Balance) AS TotalBalanceFROM Finance.UniqueBranches BLEFT JOIN Finance.UniqueAccountBranches ABON B.BranchID = AB.BranchIDLEFT JOIN Finance.UniqueAccounts AON AB.AccountID = A.AccountIDGROUP BY B.BranchName, B.Location, B.CityORDER BY B.BranchName;-- Business scenario Q163 - Doctor-Patient Appointment TrackingUSE HealthCareSELECT P.PatientID	, CONCAT(P.FirstName, ' ', P.LastName) AS PatientFullName	, P.DateOfBirth	, D.DoctorID	, CONCAT(D.FirstName, ' ', D.LastName) AS DoctorFullName	, A.AppointmentDateTime	, A.PurposeFROM Medical.Appointments AINNER JOIN Medical.Patients PON A.PatientID = P.PatientIDINNER JOIN Medical.Doctors DON A.DoctorID = D.DoctorIDORDER BY A.AppointmentDateTime;-- Business scenario Q164 - Medication Prescription and ManagementSELECT P.PatientID	, CONCAT(P.FirstName, ' ', P.LastName) AS PatientFullName	, P.DateOfBirth	, D.DoctorID	, CONCAT(D.FirstName, ' ', D.LastName) AS DoctorFullName	, D.Specialisation AS DoctorSpecialisation	, A.AppointmentDateTime	, A.Purpose	, M.MedicationName
	, M.Dosage
	, M.PrescriptionDate
	, M.ExpiryDateFROM Medical.Appointments AINNER JOIN Medical.Patients PON A.PatientID = P.PatientIDINNER JOIN Medical.Doctors DON A.DoctorID = D.DoctorIDLEFT JOIN Medical.Medications MON P.PatientID = M.PatientIDORDER BY A.AppointmentDateTime, M.PrescriptionDate;-- Business scenario Q165 - Patient Prescription History ManagementSELECT P.PatientID	, CONCAT(P.FirstName, ' ', P.LastName) AS PatientFullName	, P.DateOfBirth	, P.Gender AS PatientGender	, P.Email AS PatientEmail	, CONCAT(D.FirstName, ' ', D.LastName) AS DoctorFullName	, D.Specialisation AS DoctorSpecialisation	, M.MedicationName	, M.Dosage	, M.PrescriptionDate	, M.ExpiryDateFROM Medical.Patients PINNER JOIN Medical.Medications MON P.PatientID = M.PatientIDINNER JOIN Medical.Doctors DON M.PrescribingDoctorID = D.DoctorIDORDER BY P.PatientID, M.PrescriptionDate;