USE UEFA;

-- Business zscenario Q131 - Top Scoring Team Without Home Advantage
WITH LastThreeSeasons AS (
	SELECT TOP 3 DistinctMatches.Season
	FROM (
		SELECT DISTINCT M.SEASON AS Season
		FROM UCL.Matches M
		) AS DistinctMatches
	ORDER BY DistinctMatches.Season
	)
SELECT T.TEAM_NAME AS Team
	, SUM(M.AWAY_TEAM_SCORE) AS TotalAwayGoals
FROM UCL.Matches M
INNER JOIN UCL.Teams T ON M.AWAY_TEAM_ID = T.TEAM_ID
WHERE M.SEASON IN (SELECT Season FROM LastThreeSeasons)
GROUP BY T.TEAM_NAME 
ORDER BY SUM(M.AWAY_TEAM_SCORE) DESC
;



-- Business scenario Q132 - Most Consistent Home Team
WITH HomeAttendanceStats AS (
	SELECT M.HOME_TEAM_ID
		, MAX(M.ATTENDANCE) AS MaximumAttendance
		, MIN(M.ATTENDANCE) AS MinimumAttendance
	FROM UCL.Matches M
	GROUP BY M.HOME_TEAM_ID
	)
SELECT TOP 1 T.TEAM_NAME AS Team
	, HS.MaximumAttendance
	, HS.MinimumAttendance
	, (HS.MaximumAttendance - HS.MinimumAttendance) AS AttendanceDifference
FROM HomeAttendanceStats HS
INNER JOIN UCL.Teams T ON HS.HOME_TEAM_ID = T.TEAM_ID
ORDER BY (HS.MaximumAttendance - HS.MinimumAttendance) ASC
;



-- Business scenario Q133 - Best Defensive Away Team
SELECT T.TEAM_NAME AS Team
	, SUM(M.HOME_TEAM_SCORE) AS GoalsConceded
FROM UCL.Matches M
INNER JOIN UCL.Teams T ON M.AWAY_TEAM_ID = T.TEAM_ID
GROUP BY T.TEAM_NAME 
ORDER BY SUM(M.HOME_TEAM_SCORE) ASC
;



-- Business scenario Q134 - Young Managers in the League
SELECT CONCAT(M.FIRST_NAME, ' ', M.LAST_NAME) AS ManagerName
	, M.NATIONALITY AS Nationality
	, DATEDIFF(YEAR, M.DOB,GETDATE()) AS Age
FROM UCL.Managers M
WHERE DATEDIFF(YEAR, M.DOB,GETDATE()) < 40
ORDER BY DATEDIFF(YEAR, M.DOB,GETDATE()) ASC
;



-- Business scenario Q135 - Most Frequent Match Venue in the Latest Season
WITH StadiumStats AS (
	SELECT MAX(M.SEASON) AS Season
	FROM UCL.Matches M
	)
SELECT TOP 1 S.NAME StadiumName
	, COUNT(M.MATCH_ID) AS MatchesPlayedIn
FROM UCL.Matches M
INNER JOIN UCL.Stadiums S ON M.STADIUM = S.NAME
WHERE M.SEASON IN (SELECT SS.Season FROM StadiumStats SS)
GROUP BY S.NAME
ORDER BY COUNT(M.MATCH_ID) DESC
;