USE PremierLeague;
-- Business scenario Q51 - Top Scoring Team Analysis
SELECT TOP 5 T.TeamName
	, SUM(CombinedGoals.TotalGoals) AS TotalGoalsScored
FROM (
	SELECT M.HomeTeamID AS TeamID
		, SUM(G.FullTimeHomeGoals) AS TotalGoals
	FROM EPL.Goals G
	INNER JOIN EPL.Matches M ON G.MatchID = M.MatchID
	GROUP BY M.HomeTeamID
	UNION ALL
	SELECT M.AwayTeamID AS TeamID
		, SUM(G.FullTimeAwayGoals) AS TotalGoals
	FROM EPL.Goals G
	INNER JOIN EPL.Matches M ON G.MatchID = M.MatchID
	GROUP BY M.AwayTeamID
	) AS CombinedGoals
INNER JOIN EPL.Teams T ON CombinedGoals.TeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY SUM(CombinedGoals.TotalGoals) DESC
;


-- Business scenario Q52 - Discipline Review
SELECT TOP 5 T.TeamName
	, SUM(CombinedCards.TotalCards) AS TotalCardsReceived
FROM (
	SELECT M.HomeTeamID AS TeamID
		, SUM(C.HomeTeamYellowCards + C.HomeTeamRedCards) AS TotalCards
	FROM EPL.Cards C
	INNER JOIN EPL.Matches M ON C.MatchID = M.MatchID
	GROUP BY M.HomeTeamID
	UNION ALL
	SELECT M.AwayTeamID AS TeamID
		, SUM(C.AwayTeamYellowCards + C.AwayTeamRedCards) AS TotalCards
	FROM EPL.Cards C
	INNER JOIN EPL.Matches M ON C.MatchID = M.MatchID
	GROUP BY M.AwayTeamID
	) AS CombinedCards
INNER JOIN EPL.Teams T ON CombinedCards.TeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY SUM(CombinedCards.TotalCards) DESC
;


-- Business scenario Q53 - Defensive Prowess Analysis
SELECT TOP 5 T.TeamName
	, SUM(G.FullTimeAwayGoals) AS GoalsConceded
	, SUM(MS.AwayTeamShotsOnTarget) AS ShotsOnTargetFaced
	, ROUND(CAST(SUM(G.FullTimeAwayGoals) AS FLOAT) / CAST(NULLIF(SUM(MS.AwayTeamShotsOnTarget), 0) AS FLOAT), 3) 
		AS DefensiveEfficiency	
FROM EPL.Goals G
INNER JOIN EPL.MatchStats MS ON G.MatchID = MS.MatchID
INNER JOIN EPL.Matches M ON G.MatchID = M.MatchID
INNER JOIN EPL.Teams T ON M.HomeTeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY DefensiveEfficiency ASC
;


-- Business scenario Q54 - Underdog Triumphs 
SELECT TH.TeamName AS HomeTeam
	, TA.TeamName AS AwayTeam
	, M.MatchDate
	, M.FullTimeResult
	, MS.HomeTeamShots
	, MS.AwayTeamShots
	, G.FullTimeHomeGoals
	, G.FullTimeAwayGoals
FROM EPL.Matches M
INNER JOIN EPL.MatchStats MS ON M.MatchID = MS.MatchID
INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
INNER JOIN EPL.Teams TH ON M.HomeTeamID = TH.TeamID
INNER JOIN EPL.Teams TA ON M.AwayTeamID = TA.TeamID
WHERE (M.FullTimeResult = 'H' AND MS.AwayTeamShots - MS.HomeTeamShots >= 10)
	OR (M.FullTimeResult = 'A' AND MS.HomeTeamShots - MS.AwayTeamShots >= 10)
ORDER BY M.MatchDate
;


-- Business scenario Q55 - The Corner Game
SELECT T.TeamName
	, SUM(CombinedData.TotalCorners) AS TotalCornersWon
	, SUM(CombinedData.TotalGoals) AS TotalGoalsScored
FROM (
	SELECT M.HomeTeamID AS TeamID
		, SUM(C.HomeTeamCorners) AS TotalCorners
		, SUM(G.FullTimeHomeGoals) AS TotalGoals
	FROM EPL.Corners C
	INNER JOIN EPL.Goals G ON C.MatchID = G.MatchID
	INNER JOIN EPL.Matches M ON C.MatchID = M.MatchID
	GROUP BY M.HomeTeamID
	UNION ALL
	SELECT M.AwayTeamID AS TeamID
		, SUM(C.AwayTeamCorners) AS TotalCorners
		, SUM(G.FullTimeAwayGoals) AS TotalGoals
	FROM EPL.Corners C
	INNER JOIN EPL.Goals G ON C.MatchID = G.MatchID
	INNER JOIN EPL.Matches M ON C.MatchID = M.MatchID
	GROUP BY M.AwayTeamID
	) AS CombinedData
INNER JOIN EPL.Teams T ON CombinedData.TeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY SUM(CombinedData.TotalCorners) DESC, SUM(CombinedData.TotalGoals) DESC
;	