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


-- Business scenario Q242 - Doctor Appointment Utilisation Analysis