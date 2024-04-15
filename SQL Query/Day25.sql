-- Business scenario Q171 - Determine Hospital Visits
SELECT P.PatientID
	, P.FirstName
	, P.LastName
	, P.DateOfBirth
	, A.AppointmentDateTime
FROM Medical.Patients P
INNER JOIN Medical.Appointments A
ON P.PatientID = A.PatientID
WHERE A.AppointmentDateTime BETWEEN '2023-01-01' AND '2023-12-01'
ORDER BY A.AppointmentDateTime
;


-- Business scenario Q172 - Determine Hospital Visits for specific purpose
SELECT P.PatientID
	, P.FirstName
	, P.LastName
	, P.DateOfBirth
	, A.AppointmentDateTime
	, A.Purpose
FROM Medical.Patients P
INNER JOIN Medical.Appointments A
ON P.PatientID = A.PatientID
WHERE A.Purpose = 'Joint pain' AND DATEDIFF(YEAR,A.AppointmentDateTime,GETDATE()) < 2
;


-- Business scenario Q173 - Sales Representative Assignment
SELECT P.PatientID
	, P.FirstName
	, P.LastName
	, P.DateOfBirth
	, A.AppointmentDateTime
	, A.Purpose
	, M.MedicationName
FROM Medical.Patients P
INNER JOIN Medical.Medications M
ON P.PatientID = M.PatientID
INNER JOIN Medical.Appointments A
ON P.PatientID = A.PatientID
WHERE M.MedicationName = 'PainAway' AND A.Purpose = 'Child infections' 
AND DATEDIFF(YEAR,A.AppointmentDateTime,GETDATE()) < 10
;


-- Business scenario Q174 - Appointment Scheduling Efficiency
SELECT DATENAME(DW, A.AppointmentDateTime) AS OnWeekDay
	, DATEPART(HOUR,A.AppointmentDateTime) AS HourOfDay
	, COUNT(*) AS AppointmentCount
FROM Medical.Appointments A
GROUP BY DATENAME(DW, A.AppointmentDateTime), DATEPART(HOUR,A.AppointmentDateTime)
ORDER BY COUNT(*) DESC
;


-- Business scenario Q175 - Medication Expiry Monitoring
SELECT M.MedicationName
	, M.ExpiryDate
	, D.FirstName AS PrescribingDoctorFirstName
	, D.LastName AS PrescribingDoctorLastName
	, P.FirstName AS PatientName
	, P.LastName
FROM Medical.Medications M
INNER JOIN Medical.Doctors D
ON M.PrescribingDoctorID = D.DoctorID
INNER JOIN Medical.Patients P
ON M.PatientID = P.PatientID
WHERE M.ExpiryDate >= DATEADD(YEAR,-1,GETDATE())
;