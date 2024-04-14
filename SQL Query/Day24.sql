-- Business scenario Q166 - Benefitting from New Medication
USE HealthCare

SELECT P.PatientID
	, P.FirstName
	, P.LastName
	, P.Gender
	, P.DateOfBirth
	, P.PhoneNumber
FROM Medical.Patients P
WHERE P.PatientID IN (SELECT P.PatientID
						FROM Medical.Medications M
						WHERE M.MedicationName = 'Surgeonix'
						)
;


-- Business scenario Q167 - Commonly prescribed Age-group based medication
SELECT M.MedicationName
	, COUNT(*) AS PrescriptionCount 
FROM Medical.Medications M
WHERE M.PatientID IN (SELECT M.PatientID
							FROM Medical.Patients P
							WHERE P.DateOfBirth < '2004-01-01'
							)
GROUP BY M.MedicationName
ORDER BY COUNT(*) DESC
;


-- Business scenario Q168 - Determine which Doctor is prescribing medicine for certain purpose of hospital visits
SELECT M.PrescribingDoctorID
	, COUNT(*) AS PrescriptionCount
FROM Medical.Medications M
WHERE M.PatientID IN (SELECT A.PatientID
						FROM Medical.Appointments A
						WHERE A.Purpose = 'Child infections')
GROUP BY M.PrescribingDoctorID
ORDER BY COUNT(*) DESC
;


-- Business scenario Q169 - Determine which Doctor is prescribing a particular medicine
SELECT M.PrescribingDoctorID
	, COUNT(*) AS PrescriptionCount
FROM Medical.Medications M
WHERE M.MedicationName = 'Meditrex'
GROUP BY M.PrescribingDoctorID
ORDER BY COUNT(*)
;


-- Business scenario Q170 - Determine Average Prescription per sDoctor
SELECT D.DoctorID
	, AVG(M.MedicationID) AS AverageMedications
FROM Medical.Doctors D
INNER JOIN Medical.Appointments A
ON D.DoctorID = A.DoctorID
INNER JOIN Medical.Medications M
ON A.PatientID = M.PatientID
GROUP BY D.DoctorID
HAVING AVG(M.MedicationID) > (SELECT AVG(M.MedicationID)
								FROM Medical.Medications M)
;