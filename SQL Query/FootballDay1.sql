-- Business scenario Q1 - Stadium Analysis 
USE SOCCER_DB;
SELECT COUNT(DISTINCT MM.venue_id) AS VenueCount
FROM dbo.match_mast MM
WHERE MM.play_date LIKE '2016%'
;


-- Business scenario Q2 - Targeted Sports Marketing 
SELECT COUNT(DISTINCT MD.team_id) AS CountryCount
FROM dbo.match_details MD
WHERE MD.match_no IN (
	SELECT MM.match_no
	FROM dbo.match_mast MM
	WHERE MM.play_date LIKE '2016%'
	)
;


-- Business scenario Q3 - Analysis of On-Time Thrills: Goals Scored within 90 Minutes
SELECT COUNT(GD.goal_id) AS GoalCount
FROM dbo.goal_details GD
WHERE GD.goal_type = 'N' AND GD.goal_schedule = 'NT'
AND GD.match_no IN (
	SELECT MM.match_no
	FROM dbo.match_mast MM
	WHERE MM.play_date LIKE '2016%'
	)
;


-- Business scenario Q4 - Decisive Outcomes Analysis for Promotional Campaigns
SELECT COUNT(MD.ID) AS DecisiveWinCount
FROM dbo.match_details MD
WHERE MD.win_lose = 'W'
AND MD.match_no IN (
	SELECT MM.match_no
	FROM dbo.match_mast MM
	WHERE MM.play_date LIKE '2016%'
	)
;

-- OR
SELECT COUNT(MM.match_no) AS WinCount
FROM dbo.match_mast MM
WHERE MM.results = 'WIN' AND MM.play_date LIKE '2016%'
;


-- Business scenario Q5 - Clear Winners and Match Views
SELECT COUNT(MM.match_no) AS WinCount
FROM dbo.match_mast MM
WHERE MM.results = 'DRAW' AND MM.play_date LIKE '2016%'
;