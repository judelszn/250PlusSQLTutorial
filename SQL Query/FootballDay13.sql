-- Business scenario Q61 - The Fortress Grounds
USE PremierLeague;

SELECT T.TeamName
	, COUNT(M.MatchID) AS HomeWins
FROM EPL.Matches M
INNER JOIN EPL.Teams T ON M.HomeTeamID = T.TeamID
WHERE M.FullTimeResult = 'H'
GROUP BY T.TeamName
ORDER BY COUNT(M.MatchID) DESC
;


-- Business scenario Q62 - The Stalemate Stages
SELECT T.TeamName
	, COUNT(M.MatchID) AS TotalDraws
FROM EPL.Matches M
INNER JOIN EPL.Teams T ON M.HomeTeamID = T.TeamID OR M.AwayTeamID = T.TeamID
WHERE M.FullTimeResult = 'D'
GROUP BY T.TeamName
ORDER BY COUNT(M.MatchID) DESC
;


-- Business scenario Q63 - The Underdog Points
SELECT T.TeamName AS UnderDog
	, COUNT(*) AS PointsAgainstTop3 
FROM EPL.Matches M
INNER JOIN EPL.Teams T ON (M.HomeTeamID = T.TeamID AND M.FullTimeResult = 'H')
OR (M.AwayTeamID = T.TeamID AND M.FullTimeResult = 'A')
WHERE (M.HomeTeamID IN (SELECT TOP 3 M.HomeTeamID
						FROM EPL.Matches M
						WHERE M.FullTimeResult = 'H'
						GROUP BY M.HomeTeamID
						ORDER BY COUNT(*) DESC) 
	  OR M.AwayTeamID IN (SELECT TOP 3 M.AwayTeamID
						FROM EPL.Matches M
						WHERE M.FullTimeResult = 'A'
						GROUP BY M.AwayTeamID
						ORDER BY COUNT(*) DESC))
	  AND T.TeamID NOT IN (SELECT TOP 3 M.HomeTeamID
							FROM EPL.Matches M
							WHERE M.FullTimeResult = 'H'
							GROUP BY M.HomeTeamID
							ORDER BY COUNT(*) DESC)
	  AND T.TeamID NOT IN (SELECT TOP 3 M.AwayTeamID
							FROM EPL.Matches M
							WHERE M.FullTimeResult = 'A'
							GROUP BY M.AwayTeamID
							ORDER BY COUNT(*) DESC)
GROUP BY T.TeamName
ORDER BY COUNT(*) DESC
;


-- Business scenario Q64 - Goals Galore
SELECT M.MatchDate
	, CONVERT(DATE, M.MatchDate) AS MatchDay
	, SUM(G.FullTimeHomeGoals + G.FullTimeAwayGoals) AS TotalGoals
FROM EPL.Matches M
INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
GROUP BY M.MatchDate
ORDER BY  SUM(G.FullTimeHomeGoals + G.FullTimeAwayGoals) DESC
;


-- Business scenario Q65 - The Home Comforts
SELECT T.TeamName
	, SUM(G.FullTimeHomeGoals) AS TotalHomeGoals
FROM EPL.Matches M
INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
INNER JOIN EPL.Teams T ON M.HomeTeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY SUM(G.FullTimeHomeGoals) DESC
;