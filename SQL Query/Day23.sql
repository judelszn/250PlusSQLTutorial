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


-- Business scenario Q162 - Branch-wise Account Balance Summary
	, M.Dosage
	, M.PrescriptionDate
	, M.ExpiryDate