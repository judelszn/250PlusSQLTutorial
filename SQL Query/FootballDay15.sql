USE PremierLeague;

-- Business scenario Q71 - Tough Starters
SELECT TOP 1 
	CASE
		WHEN M.FullTimeResult = 'H' THEN M.AwayTeamID
		ELSE M.HomeTeamID
	END AS LosingTeam
FROM EPL.Matches M
ORDER BY M.MatchDate ASC
;


-- Business scenario Q72 - The Dominant Display
SELECT TOP 1 M.HomeTeamID
	, M.AwayTeamID
	, G.FullTimeHomeGoals
	, G.FullTimeAwayGoals
	, ABS(G.FullTimeHomeGoals - G.FullTimeAwayGoals) AS GoalDifference
FROM EPL.Matches M
INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
ORDER BY ABS(G.FullTimeHomeGoals - G.FullTimeAwayGoals) DESC, M.MatchDate ASC
;


-- Business scenario Q73 - The Nail-Biters
SELECT TOP 1 M.HomeTeamID
	, M.AwayTeamID
	, G.FullTimeHomeGoals
	, G.FullTimeAwayGoals
	, ABS(G.FullTimeHomeGoals - G.FullTimeAwayGoals) AS GoalDifference
FROM EPL.Matches M
INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
WHERE G.FullTimeHomeGoals > 0 AND G.FullTimeAwayGoals > 0
ORDER BY ABS(G.FullTimeHomeGoals - G.FullTimeAwayGoals) ASC , M.MatchDate ASC
;


-- Business scenario Q74 - The Away Day Dominators
SELECT T.TeamName
	, COUNT(M.MatchID) AS AwayWins
FROM EPL.Matches M
INNER JOIN EPL.Teams T ON M.AwayTeamID = T.TeamID
WHERE M.FullTimeResult = 'A'
GROUP BY T.TeamName
ORDER BY COUNT(M.MatchID) DESC
;


-- Business scenario Q75 - The Unbreakable Defence
SELECT T.TeamName
	, SUM(G.FullTimeAwayGoals) AS HomeGoalsConceded
FROM EPL.Matches M
INNER JOIN EPL.Goals G ON M.MatchID = G.MatchID
INNER JOIN EPL.Teams T ON M.HomeTeamID = T.TeamID
GROUP BY T.TeamName
ORDER BY SUM(G.FullTimeAwayGoals) ASC
;