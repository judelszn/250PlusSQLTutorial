USE WorldCup;

-- Business scenario Q91 - Tightest World Cup Race
SELECT W.Year
	, W.Winner
	, SUM(CASE WHEN W.Winner = M.Home_Team_Name THEN M.Home_Team_Goals ELSE M.Away_Team_Goals END) AS GoalsFor
	, SUM(CASE WHEN Winner = M.Home_Team_Name THEN Away_Team_Goals ELSE M.Home_Team_Goals END) AS GoalAgainst
FROM WC.WorldCupMatches M
INNER JOIN WC.WorldCups W ON M.Year = W.Year
WHERE W.Winner IS NOT NULL
GROUP BY W.Year, W.Winner
ORDER BY  ABS(SUM(CASE WHEN W.Winner = M.Home_Team_Name THEN M.Home_Team_Goals ELSE M.Away_Team_Goals END)
- SUM(CASE WHEN Winner = M.Home_Team_Name THEN Away_Team_Goals ELSE M.Home_Team_Goals END)) DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;


-- Business scenario Q92 - Surprising Finalists
SELECT W.Year
	, W.Winner
	, W.Runners_Up
	, SUM(CASE WHEN W.Winner = M.Home_Team_Name THEN M.Home_Team_Goals ELSE M.Away_Team_Goals END)
	 + SUM(CASE WHEN W.Runners_Up = M.Home_Team_Name THEN M.Home_Team_Goals ELSE M.Away_Team_Goals END) AS TotalGoals
FROM WC.WorldCupMatches M
INNER JOIN WC.WorldCups W ON M.Year = W.Year
WHERE (M.Home_Team_Name = W.Winner OR M.Away_Team_Name = W.Winner
	OR M.Home_Team_Name = W.Runners_Up OR M.Away_Team_Name = W.Runners_Up) AND M.Stage != 'Final'
GROUP BY W.Year, W.Winner, W.Runners_Up
ORDER BY TotalGoals DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;


-- Business scenario Q93 - The Unexpected Third
SELECT W.Year
	, W.Third AS ThirdPlacedTeam
	, COUNT(M.MatchID) AS MatchesWon
	, SUM(CASE WHEN W.Third = M.Home_Team_Name THEN M.Home_Team_Goals ELSE M.Away_Team_Goals END) AS GoalsScored
FROM WC.WorldCupMatches M
INNER JOIN WC.WorldCups W ON M.Year = W.Year
WHERE (W.Third = M.Home_Team_Name AND M.Home_Team_Goals > M.Away_Team_Goals) 
	OR (W.Third = M.Away_Team_Name AND M.Away_Team_Goals > M.Home_Team_Goals)
GROUP BY W.Year, W.Third
ORDER BY GoalsScored DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;


-- Business scenario Q94 - Dramatic Turnarounds
SELECT M.Year
	, M.Home_Team_Name
	, M.Away_Team_Name
	, M.Half_time_Home_Goals AS HalfTimeHomeGoals
	, M.Half_time_Away_Goals AS HalfTimeAwayGoals
	, M.Home_Team_Goals AS FinalHomeGoals
	, M.Away_Team_Goals AS FinalAwayGoals
FROM WC.WorldCupMatches M
WHERE (M.Half_time_Home_Goals - M.Half_time_Away_Goals > 0 AND M.Home_Team_Goals <= M.Away_Team_Goals) 
	OR (M.Half_time_Away_Goals - M.Half_time_Home_Goals > 0 AND M.Away_Team_Goals <= M.Home_Team_Goals)
ORDER BY ABS(M.Half_time_Home_Goals - M.Half_time_Away_Goals) DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;


-- Business scenario Q95 - Referee's Busy Day
SELECT M.Year
	, M.Home_Team_Name AS HomeTeam
	, M.Away_Team_Name AS AwayTeam
	, M.Referee
	, COUNT(P.Event) AS NumberOfEvents
FROM WC.WorldCupMatches M
INNER JOIN WC.WorldCupPlayers P ON M.MatchID = P.MatchID
WHERE P.Event IS NOT NULL
GROUP BY M.Year, M.Home_Team_Name, M.Away_Team_Name, M.Referee
ORDER BY COUNT(P.Event) DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;