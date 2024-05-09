-- Business scenario Q6 - EURO 2016 Kick-off Date
USE SOCCER_DB;
SELECT MIN(MM.play_date) AS KickOffDay
FROM dbo.match_mast MM
WHERE MM.play_date LIKE '2016%'
;



-- Business scenario Q7 - Analysis of Own Goals
SELECT COUNT(GD.goal_id) AS OwnGoalCount
FROM dbo.goal_details GD
WHERE GD.goal_type = 'O' AND
GD.match_no IN (
	SELECT MM.match_no
	FROM dbo.match_mast MM
	WHERE MM.play_date LIKE '2016%'
	)
;


-- Business scenario Q8 - Decisive Group Stage Matches
SELECT COUNT(MD.ID) AS WinnerCount
FROM dbo.match_details MD
WHERE MD.win_lose = 'W' AND MD.play_stage = 'G' AND
MD.match_no IN (
	SELECT MM.match_no
	FROM dbo.match_mast MM
	WHERE MM.play_date LIKE '2016%'
	)
;
-- OR 
SELECT COUNT(MM.match_no) AS WinCount
FROM dbo.match_mast MM
WHERE MM.results = 'WIN' AND MM.play_stage = 'G' AND MM.play_date LIKE '2016%'
;


-- Business scenario Q9 - Analysis of Penalty Shootouts
SELECT COUNT(MM.match_no) AS PenaltyShoutsCount
FROM DBO.match_mast MM
WHERE MM.play_date LIKE '2016%' AND MM.decided_by = 'P'
;


-- .Business scenario Q10 - Analysis of Round of 16 PenaltiesSELECT COUNT(MM.match_no) AS Round16PenaltyShoutsCountFROM dbo.match_mast MMWHERE MM.play_date LIKE '2016%' AND MM.play_stage = 'R' AND MM.decided_by = 'P';