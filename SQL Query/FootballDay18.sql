USE PremierLeague;

-- Business scenario Q86 - The Comeback Kings 2
WITH ComeBackTeams AS (
	SELECT
		CASE
		WHEN M.HalfTimeResult = 'A' THEN M.HomeTeamID
		WHEN M.HalfTimeResult = 'H' THEN M.AwayTeamID
	   END AS TeamID
	   , M.MatchID
	FROM EPL.Matches M
	WHERE (M.HalfTimeResult = 'A' AND M.FullTimeResult = 'H')
	OR (M.HalfTimeResult = 'H' AND M.FullTimeResult = 'A')
	)
SELECT T.TeamName
	, COUNT(CT.MatchID) AS WinsCount
FROM ComeBackTeams CT
INNER JOIN EPL.Teams T ON CT.TeamID = T.TeamID
GROUP BY T.TeamName
;


USE WorldCup;

-- Business scenario Q87 - World Cup Hosting Highlights
SELECT Country
	, TimesHosted
	, TotalGoalsScored
FROM (
	SELECT W.Country
		, COUNT(*) AS TimesHosted
		, SUM(W.GoalsScored) AS TotalGoalsScored
		, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC, SUM(W.GoalsScored) DESC) AS RowNumber
	FROM WC.WorldCups W
	GROUP BY W.Country
	) AS RankedCountries
WHERE RowNumber = 1
;


-- Business scenario Q88 - Top Goal-Scoring Tournament
SELECT W.Year
	, W.Country
	, W.GoalsScored
FROM WC.WorldCups W
ORDER BY W.GoalsScored DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;


-- Business scenario Q89 - Most Attended World Cup
SELECT TOP 1 W.Year
	, W.Country
	, W.Attendance
FROM WC.WorldCups W
WHERE W.Attendance IS NOT NULL
ORDER BY W.Attendance DESC
;


-- Business scenario Q90 - World Cup UnderdogsSELECT W.Year	, W.Country	, W.Winner	, W.GoalsScoredFROM WC.WorldCups WWHERE W.Winner IS NOT NULLORDER BY W.GoalsScored ASCOFFSET 0 ROWSFETCH NEXT 1 ROWS ONLY;