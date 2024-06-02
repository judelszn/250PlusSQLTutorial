USE UEFA;

-- Business scenario Q126 - Busiest Stadium
SELECT TOP 1 S.NAME AS StatiumName
	, S.CITY AS City
	, S.COUNTRY AS Country
	, COUNT(M.MATCH_ID) AS MatchesHosted
FROM UCL.Matches M
INNER JOIN UCL.Stadiums S ON M.STADIUM = S.NAME
GROUP BY S.NAME, S.COUNTRY, S.CITY
ORDER BY COUNT(M.MATCH_ID) DESC
;



-- Business scenario Q127 - Most Travelled Team
SELECT TOP 1 T.TEAM_NAME AS Team
	, COUNT(M.MATCH_ID) AS AwayMatches
FROM UCL.Matches M
INNER JOIN UCL.Teams T ON M.AWAY_TEAM_ID = T.TEAM_ID
GROUP BY TEAM_NAME
ORDER BY COUNT(M.MATCH_ID) DESC
;



-- Business scenario Q128 - Ranking some of the Most Popular Home Venue
SELECT TOP 1 S.NAME AS Stadium
	, T.TEAM_NAME AS HomeTeam
	, ROUND(AVG(M.ATTENDANCE), 2) AS AverageAttendance
FROM UCL.Matches M 
INNER JOIN UCL.Teams T ON M.HOME_TEAM_ID = T.TEAM_ID
INNER JOIN UCL.Stadiums S ON T.HOME_STADIUM = S.STADIUM_ID
GROUP BY S.NAME, T.TEAM_NAME
ORDER BY ROUND(AVG(M.ATTENDANCE), 2) DESC
;



-- Business scenario Q129 - Ranking teams with Most Diverse Nationalities