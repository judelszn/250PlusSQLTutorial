USE WorldCup;

-- Business scenario Q101 - Low Scoring Winners
SELECT W.Year
	, W.Winner
	, SUM(CASE WHEN W.Winner = M.Home_Team_Name THEN M.Home_Team_Goals ELSE M.Away_Team_Goals END) AS GoalsScored
FROM WC.WorldCupMatches M
INNER JOIN WC.WorldCups W ON M.Year = W.Year
WHERE M.Home_Team_Name = W.Winner OR M.Away_Team_Name = W.Winner
GROUP BY W.Year, W.Winner
ORDER BY GoalsScored ASC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;



-- Business scenario Q102 - Goalkeeper's Nightmare
SELECT M.Year
	, M.Stadium
	, SUM(M.Home_Team_Goals + M.Away_Team_Goals) AS TotalGoals
FROM WC.WorldCupMatches M
GROUP BY M.Year, M.Stadium
ORDER BY SUM(M.Home_Team_Goals + M.Away_Team_Goals) DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;



-- Business scenario Q103 - Decade of Dominance
SELECT W.Winner
	, (W.Year/10) * 10 as DecadeStart
	, COUNT(W.Winner) AS TitlesWon
FROM WC.WorldCups W
GROUP BY W.Winner, (W.Year/10) * 10
ORDER BY COUNT(W.Winner) DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;



-- Business scenario Q104 - Closest Contests
SELECT M.Year
	, COUNT(M.MatchID) AS CloseMatches
FROM WC.WorldCupMatches M
WHERE ABS(M.Home_Team_Goals - M.Away_Team_Goals) <= 1
GROUP BY M.Year
ORDER BY COUNT(M.MatchID) DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;



-- Business scenario Q105 - The Unyielding Fortress
SELECT W.Year
	, W.Winner
	, SUM(CASE WHEN W.Winner = M.Home_Team_Name THEN M.Away_Team_Goals ELSE M.Home_Team_Goals END)
		AS GoalsConceded
FROM WC.WorldCupMatches M
INNER JOIN WC.WorldCups W ON M.Year = W.Year
WHERE M.Home_Team_Name = W.Winner OR M.Away_Team_Name = W.Winner
GROUP BY W.Year, W.Winner
ORDER BY GoalsConceded ASC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;