USE PremierLeague;

-- Business scenario Q66 - The Draw Specialists
SELECT T.TeamName
	, COUNT(M.MatchID) AS DrawCount
FROM EPL.Matches M
INNER JOIN EPL.Teams T ON M.HomeTeamID = T.TeamID OR M.AwayTeamID = T.TeamID
WHERE M.FullTimeResult = 'D'
GROUP BY T.TeamName
ORDER BY COUNT(M.MatchID) DESC
;


-- Business scenario Q67 - Fortress Denied
SELECT T.TeamName
	, COUNT(M.MatchID) AS HomeLossCount
FROM EPL.Matches M
INNER JOIN EPL.Teams T ON M.HomeTeamID = T.TeamID
WHERE M.FullTimeResult = 'A'
GROUP BY T.TeamName
ORDER BY COUNT(M.MatchID) DESC
;


-- Business scenario Q68 - Away Day Blues
SELECT T.TeamName
	, COUNT(M.MatchID) AS AwayLossCount
FROM EPL.Matches M
INNER JOIN EPL.Teams T ON M.AwayTeamID = T.TeamID
WHERE M.FullTimeResult = 'H'
GROUP BY T.TeamName
ORDER BY COUNT(M.MatchID) DESC
;


-- Business scenario Q69 - The Early Birds
SELECT TOP 1 CASE
				WHEN M.FullTimeResult = 'H' THEN HomeTeamID
				ELSE AwayTeamID
			END AS WinningTeamID
FROM EPL.Matches M
--INNER JOIN EPL.Teams T ON M.HomeTeamID = T.TeamID OR M.AwayTeamID = T.TeamID
ORDER BY M.MatchDate ASC
;


-- Business scenario Q70 - The Goalless Streak
SELECT TOP 1
	M.HomeTeamID
	, M.AwayTeamID
FROM EPL.Matches M
INNER JOIN EPL.Goals G ON M.MatchID = M.MatchID
WHERE G.FullTimeHomeGoals = 0 AND G.FullTimeAwayGoals = 0
ORDER BY M.MatchDate
; 