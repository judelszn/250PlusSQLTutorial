-- Business scenario Q61 - The Fortress Grounds
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
SELECT *
FROM EPL.Matches M
INNER JOIN EPL.Teams T ON (M.HomeTeamID = T.TeamID AND M.FullTimeResult = 'H')
OR (M.AwayTeamID = T.TeamID AND M.FullTimeResult = 'A')
WHERE ()
;