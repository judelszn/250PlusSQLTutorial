USE PremierLeague;

-- Business scenario Q81 - The Comeback Kings
WITH TwoGoalsDeficit AS (
	SELECT M.HomeTeamID
		, M.AwayTeamID
		, G.HalfTimeHomeGoals
		, G.HalfTimeAwayGoals
		, G.FullTimeHomeGoals
		, G.FullTimeAwayGoals
	FROM EPL.Matches M
	INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
	WHERE (G.HalfTimeAwayGoals - G.HalfTimeHomeGoals >= 2 AND (M.FullTimeResult = 'H' OR M.FullTimeResult = 'D')) 
		OR (G.HalfTimeHomeGoals - G.HalfTimeAwayGoals >= 2 AND (M.FullTimeResult = 'A' OR M.FullTimeResult = 'D'))
	)
SELECT T.TeamName
	, COUNT(*) AS ComeBackInstances
FROM TwoGoalsDeficit TD
INNER JOIN EPL.Teams T ON TD.HomeTeamID = T.TeamID OR TD.AwayTeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY COUNT(*) DESC
;


-- Business scenario Q82 - The Traveling Troubles
WITH AwayStats AS (
	SELECT M.AwayTeamID
		, COUNT(*) AS TotalAwayMatches
		, SUM(
			CASE WHEN M.FullTimeResult = 'A' THEN 1 ELSE 0 END) AS AwayWins 
	FROM EPL.Matches M
	GROUP BY M.AwayTeamID
	)
SELECT T.TeamName
	, WS.TotalAwayMatches
	, WS.AwayWins
	, CAST(WS.AwayWins AS FLOAT) / WS.TotalAwayMatches * 100 AS AwayWinPercentage
FROM AwayStats WS
INNER JOIN EPL.Teams T ON WS.AwayTeamID = T.TeamID
ORDER BY AwayWinPercentage DESC
;


-- Business scenario Q83 - The Second Half Shift
WITH HalfWiseDifference AS (
	SELECT M.HomeTeamID
		, M.AwayTeamID
		, ABS(G.HalfTimeHomeGoals - G.HalfTimeAwayGoals) AS FirstHalfGoalDifference
		, ABS((G.FullTimeHomeGoals - G.HalfTimeHomeGoals) - (G.FullTimeAwayGoals - G.HalfTimeAwayGoals)) AS SecondHalfGoalDifference
	FROM EPL.Matches M
	INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
	)
SELECT T.TeamName
	, SUM(CASE WHEN T.TeamID = HD.HomeTeamID THEN FirstHalfGoalDifference ELSE -FirstHalfGoalDifference END) AS TotalFirstHalfGoalDifference
	, SUM(CASE WHEN T.TeamID = HD.HomeTeamID THEN SecondHalfGoalDifference ELSE -SecondHalfGoalDifference END) AS TotalSecondHalfGoalDifference
	, SUM(CASE WHEN T.TeamID = HD.HomeTeamID THEN FirstHalfGoalDifference ELSE -FirstHalfGoalDifference END)
		- SUM(CASE WHEN T.TeamID = HD.HomeTeamID THEN SecondHalfGoalDifference ELSE -SecondHalfGoalDifference END)
		AS Improvement
FROM HalfWiseDifference HD
INNER JOIN EPL.Teams T ON HD.HomeTeamID = T.TeamID OR HD.AwayTeamID = T.TeamID
GROUP BY T.TeamName 
ORDER BY Improvement DESC
;


-- Business scenario Q84 - The Stalemate Specialists
WITH DrawStats AS (
	SELECT M.HomeTeamID AS TeamID
		, COUNT(*) AS Draws
	FROM EPL.Matches M
	WHERE M.FullTimeResult = 'D'
	GROUP BY M.HomeTeamID
	UNION ALL
	SELECT M.AwayTeamID AS TeamID
		, COUNT(*) AS Draws
	FROM EPL.Matches M
	WHERE M.FullTimeResult = 'D'
	GROUP BY M.AwayTeamID
	)
SELECT T.TeamName
	, SUM(ds.Draws) AS TotalDraws
FROM DrawStats DS
INNER JOIN EPL.Teams T ON DS.TeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY SUM(ds.Draws) DESC
;


-- Business scenario Q85 - The Fortress Défense
WITH HomeConcededGoals AS (
	SELECT M.HomeTeamID
		, SUM(G.FullTimeAwayGoals) AS TotalAwayGoals
	FROM EPL.Matches M 
	INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
	GROUP BY M.HomeTeamID
	)
SELECT T.TeamName
	, SUM(HG.TotalAwayGoals) AS TotalHomeGoalsConceded
FROM HomeConcededGoals HG
INNER JOIN EPL.Teams T ON HG.HomeTeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY SUM(HG.TotalAwayGoals) ASC
;