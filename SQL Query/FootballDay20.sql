USE WorldCup;

-- Business scenario Q96 - Rookie Nations' Debut
SELECT W.Year
	, COUNT(W.Country) AS DebutingCountries
FROM WC.WorldCups W
WHERE W.Year - 4 NOT IN (SELECT DISTINCT W.Year FROM WC.WorldCups W)
GROUP BY W.Year
ORDER BY  COUNT(W.Country) DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;


-- Business scenario Q97 - Decisive Finals
SELECT M.Year
	, M.Home_Team_Name AS HomeTeam
	, M.Away_Team_Name AS AwayTeam
	, ABS(M.Home_Team_Goals - M.Away_Team_Goals) AS GoalDifference
FROM WC.WorldCupMatches M
INNER JOIN WC.WorldCups W ON M.Year = W.Year
WHERE M.Stage = 'Final' AND (M.Home_Team_Name = W.Winner OR M.Away_Team_Name = W.Winner)
ORDER BY ABS(M.Home_Team_Goals - M.Away_Team_Goals) DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;


-- Business scenario Q98 - Early Bird Champions
SELECT M.Year
	, W.Winner AS WinningTeam
	, SUM(CASE WHEN W.Winner = M.Home_Team_Name THEN M.Home_Team_Goals ELSE M.Away_Team_Goals END) AS GoalsScored
FROM WC.WorldCupMatches M
INNER JOIN WC.WorldCups W ON M.Year = W.Year
WHERE M.Stage LIKE 'Group%' AND (M.Home_Team_Name = W.Winner OR M.Away_Team_Name = W.Winner)
GROUP BY M.Year, W.Winner
ORDER BY GoalsScored DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;


-- Business scenario Q99 - Hosts' Heartbreak
SELECT W.Year
	, W.Country AS HostNation
FROM WC.WorldCups W
WHERE W.Country = W.Runners_Up
;


-- Business scenario Q100 - Consistent Contenders
SELECT TopFourTeams.Country
	, COUNT(TopFourTeams.Country) AS TopFourFinishes
FROM (
	SELECT W.Winner AS Country
	FROM WC.WorldCups W
	UNION ALL
	SELECT W.Runners_Up AS Country
	FROM WC.WorldCups W
	UNION ALL
	SELECT W.Third AS Country
	FROM WC.WorldCups W
	UNION ALL
	SELECT W.Fourth AS Country
	FROM WC.WorldCups W
	) AS TopFourTeams
GROUP BY TopFourTeams.Country
ORDER BY COUNT(TopFourTeams.Country) DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;