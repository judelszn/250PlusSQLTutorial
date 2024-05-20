USE PremierLeague;

-- Business scenario Q56 - First Half Dominance
SELECT TH.TeamName AS HomeTeam
	, TA.TeamName AS AwayTeam
	, M.MatchDate
	, G.HalfTimeHomeGoals
	, G.HalfTimeAwayGoals
	, G.FullTimeHomeGoals
	, G.FullTimeAwayGoals
	, M.FullTimeResult
FROM EPL.Matches M
INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
INNER JOIN EPL.Teams TH ON M.HomeTeamID = TH.TeamID
INNER JOIN EPL.Teams TA ON M.AwayTeamID = TA.TeamID
WHERE (M.FullTimeResult = 'H' AND G.HalfTimeAwayGoals - G.HalfTimeHomeGoals >= 2)
	OR (M.FullTimeResult = 'A' AND G.HalfTimeHomeGoals - G.HalfTimeAwayGoals >= 2)
	OR (M.FullTimeResult = 'D' AND (G.HalfTimeAwayGoals - G.HalfTimeHomeGoals >= 2 
	OR G.HalfTimeHomeGoals - G.HalfTimeAwayGoals >= 2 ))
ORDER BY M.MatchDate
;


-- .Business scenario Q57 - The Fair Play Teams
SELECT T.TeamName
	, SUM(CombinedFouls.TotalFouls) AS TotalFoulsCommitted
FROM (
	SELECT M.HomeTeamID AS TeamID
		, SUM(MS.HomeTeamFouls) AS TotalFouls
	FROM EPL.MatchStats MS
	INNER JOIN EPL.Matches M ON MS.MatchID = M.MatchID
	GROUP BY M.HomeTeamID 
	UNION ALL
	SELECT M.AwayTeamID AS TeamID
		, SUM(MS.AwayTeamFouls) AS TotalFouls
	FROM EPL.MatchStats MS
	INNER JOIN EPL.Matches M ON MS.MatchID = M.MatchID
	GROUP BY M.AwayTeamID
	) AS CombinedFouls
INNER JOIN EPL.Teams T ON CombinedFouls.TeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY SUM(CombinedFouls.TotalFouls) ASC
;


-- Business scenario Q58 - The Resilient Defenders
SELECT T.TeamName
	, SUM(CombinedData.TotalCorners) AS TotalCorrneesFaced
	, SUM(CombinedData.TotalGoals) AS TotalGoalsConceded
	, CAST(SUM(CombinedData.TotalGoals) AS FLOAT) / CAST(NULLIF(SUM(CombinedData.TotalCorners), 0) AS FLOAT) AS DefensiveReslienceScore
FROM (
	SELECT M.HomeTeamID AS TeamID
		, SUM(C.AwayTeamCorners) AS TotalCorners
		, SUM(G.FullTimeAwayGoals) AS TotalGoals 
	FROM EPL.Corners C
	INNER JOIN EPL.Goals G ON C.MatchID = G.MatchID
	INNER JOIN EPL.Matches M ON C.MatchID = M.MatchID
	GROUP BY M.HomeTeamID
	UNION ALL
	SELECT M.AwayTeamID AS TeamID
		, SUM(C.HomeTeamCorners) AS TotalCorners
		, SUM(G.FullTimeHomeGoals) AS TotalGoals 
	FROM EPL.Corners C
	INNER JOIN EPL.Goals G ON C.MatchID = G.MatchID
	INNER JOIN EPL.Matches M ON C.MatchID = M.MatchID
	GROUP BY M.AwayTeamID
	) AS CombinedData
INNER JOIN EPL.Teams T ON CombinedData.TeamID = T.TeamID
GROUP BY T.TeamName
;


-- Business scenario Q59 - The Thriller MatchesSELECT TH.TeamName AS HomeTeam	, TA.TeamName AS AwayTeam	, M.MatchDate	, M.FullTimeResult	, MS.HomeTeamShots	, MS.AwayTeamShots	, (MS.HomeTeamShots + MS.AwayTeamShots) AS CombinedShotsOnTargetFROM EPL.MatchStats MSINNER JOIN EPL.Matches M ON MS.MatchID = M.MatchIDINNER JOIN EPL.Teams TH ON M.HomeTeamID = TH.TeamIDINNER JOIN EPL.Teams TA ON M.AwayTeamID = TA.TeamIDORDER BY (MS.HomeTeamShots + MS.AwayTeamShots) DESC;-- Business scenario Q60 - The Clean Sheet MastersSELECT T.TeamName	, COUNT(CleanSheets.MatchID) AS TotalCleanSheetsFROM (	SELECT M.HomeTeamID AS TeamID		, M.MatchID 	FROM EPL.Matches M	INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID	WHERE G.FullTimeAwayGoals = 0	UNION ALL	SELECT M.AwayTeamID AS TeamID		, M.MatchID 	FROM EPL.Matches M	INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID	WHERE G.FullTimeHomeGoals = 0	) AS CleanSheetsINNER JOIN EPL.Teams T ON CleanSheets.MatchID = T.TeamIDGROUP BY T.TeamNameORDER BY COUNT(CleanSheets.MatchID) DESC;