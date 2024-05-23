USE PremierLeague;

-- Business scenario Q76 - The Big Starters
SELECT T.TeamName
	, SUM(G.HalfTimeHomeGoals + G.HalfTimeAwayGoals) AS TotalFirstHalfGoals
FROM EPL.Matches M
INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
INNER JOIN EPL.Teams T ON M.HomeTeamID = T.TeamID OR M.AwayTeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY SUM(G.HalfTimeHomeGoals + G.HalfTimeAwayGoals) DESC
;


-- Business scenario Q77 - The Late BloomersSELECT T.TeamName
	, SUM((G.FullTimeHomeGoals - G.HalfTimeHomeGoals) + (G.FullTimeAwayGoals - G.HalfTimeAwayGoals))
		AS TotalSecondHalfGoals
FROM EPL.Matches M
INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
INNER JOIN EPL.Teams T ON M.HomeTeamID = T.TeamID OR M.AwayTeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY TotalSecondHalfGoals DESC
;


-- Business scenario Q78 - The Tactical Switch
WITH HalfTimeDeficit AS (
	SELECT M.HomeTeamID
		, M.AwayTeamID
		, G.HalfTimeHomeGoals
		, G.HalfTimeAwayGoals
		, M.FullTimeResult
	FROM EPL.Matches M
	INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
	WHERE (G.HalfTimeHomeGoals < G.HalfTimeAwayGoals AND M.FullTimeResult = 'H') 
	OR (G.HalfTimeAwayGoals < G.HalfTimeHomeGoals AND M.FullTimeResult = 'A')
	)
SELECT T.TeamName
	, COUNT(*) AS ComeBackWins
FROM HalfTimeDeficit HD
INNER JOIN EPL.Teams T ON HD.HomeTeamID = T.TeamID OR HD.HomeTeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY COUNT(*) DESC
;


-- Business scenario Q79 - The Second-Half Surge
WITH SecondHalfGoals AS (
	SELECT M.HomeTeamID
		, M.AwayTeamID
		, G.FullTimeHomeGoals - G.HalfTimeHomeGoals AS SecondHalfHomeGoals
		, G.FullTimeAwayGoals - G.HalfTimeAwayGoals AS SecondHalfAwayGoals
	FROM EPL.Matches M
	INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
	)
SELECT T.TeamName
	, AVG(CASE
			WHEN T.TeamID = SG.HomeTeamID THEN SG.SecondHalfHomeGoals
			ELSE SG.SecondHalfAwayGoals
		  END 
		) AS AverageSecondHalfGoals
FROM SecondHalfGoals SG
INNER JOIN EPL.Teams T ON SG.HomeTeamID = T.TeamID OR SG.AwayTeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY AverageSecondHalfGoals DESC
;


-- Business scenario Q80 - The Resilient Defence
WITH FirstHalfConceding AS (
	SELECT M.HomeTeamID
		, M.AwayTeamID
		, G.HalfTimeHomeGoals
		, G.HalfTimeAwayGoals
		, G.FullTimeHomeGoals - G.HalfTimeHomeGoals AS SecondHalfHomeGoals
		, G.FullTimeAwayGoals - G.HalfTimeAwayGoals AS SecondHalfAwayGoals
	FROM EPL.Matches M
	INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
	WHERE (G.HalfTimeHomeGoals > 0 AND (G.FullTimeHomeGoals - G.HalfTimeHomeGoals = 0))
		OR (G.HalfTimeAwayGoals > 0 AND (G.FullTimeAwayGoals - G.HalfTimeAwayGoals = 0))
	)
SELECT T.TeamName
	, COUNT(*) AS SecondHalfResilience
FROM FirstHalfConceding FC
INNER JOIN EPL.Teams T ON FC.HomeTeamID = T.TeamID OR FC.AwayTeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY COUNT(*) DESC
;