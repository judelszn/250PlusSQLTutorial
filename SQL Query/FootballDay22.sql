USE WorldCup;

-- Business scenario Q106 - Giant Slayers
SELECT M.Year
	, CASE
		WHEN M.Home_Team_Goals > M.Away_Team_Goals THEN M.Home_Team_Name
		ELSE M.Away_Team_Name
	  END AS GiantSlayer
	, COUNT(DISTINCT CASE
			WHEN M.Home_Team_Goals > M.Away_Team_Goals THEN M.Away_Team_Name
			ELSE M.Home_Team_Name
			END) AS FormerWinnerDefeated
FROM WC.WorldCupMatches M
WHERE ((M.Home_Team_Goals > M.Away_Team_Goals AND M.Away_Team_Name IN (SELECT DISTINCT W.Winner
																		FROM WC.WorldCups W
																		WHERE W.Year < M.Year))
		OR (M.Away_Team_Goals > M.Home_Team_Goals AND M.Home_Team_Name IN (SELECT DISTINCT W.Winner
																			FROM WC.WorldCups W
																			WHERE W.Year < M.Year)))
	AND M.Year NOT IN (SELECT DISTINCT W.Year
						FROM WC.WorldCups W
						WHERE W.Winner = M.Home_Team_Name OR W.Winner = M.Away_Team_Name)
GROUP BY M.Year
	, CASE
		WHEN M.Home_Team_Goals > M.Away_Team_Goals THEN M.Home_Team_Name
		ELSE M.Away_Team_Name
	  END
ORDER BY FormerWinnerDefeated DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;


-- Business scenario Q107 - Comeback Kids
SELECT M.Year
	, CASE
		WHEN M.Half_time_Home_Goals < M.Half_time_Away_Goals AND M.Home_Team_Goals > M.Away_Team_Goals THEN M.Home_Team_Name
		WHEN M.Half_time_Away_Goals < M.Half_time_Home_Goals AND M.Away_Team_Goals > M.Home_Team_Goals THEN M.Away_Team_Name
		ELSE NULL
	  END ComeBackTeam
	, COUNT(M.MatchID) AS ComeBackWins
FROM WC.WorldCupMatches M
WHERE (M.Half_time_Home_Goals < M.Half_time_Away_Goals AND M.Home_Team_Goals > M.Away_Team_Goals)
	OR (M.Half_time_Away_Goals < M.Half_time_Home_Goals AND M.Away_Team_Goals > M.Home_Team_Goals)
GROUP BY M.Year
	, CASE
		WHEN M.Half_time_Home_Goals < M.Half_time_Away_Goals AND M.Home_Team_Goals > M.Away_Team_Goals THEN M.Home_Team_Name
		WHEN M.Half_time_Away_Goals < M.Half_time_Home_Goals AND M.Away_Team_Goals > M.Home_Team_Goals THEN M.Away_Team_Name
		ELSE NULL
	  END
ORDER BY COUNT(M.MatchID) DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;



-- Business scenario Q108 - Late BloomersSELECT M.Year	, CASE 		WHEN P.Team_Initials = M.Home_Team_Initials THEN M.Home_Team_Name		ELSE M.Away_Team_Name	  END AS Team	, COUNT(P.Event) AS LateGoalsFROM WC.WorldCupMatches MINNER JOIN WC.WorldCupPlayers P ON M.MatchID = P.MatchIDWHERE (P.Event LIKE '%G%' AND ISNUMERIC(LEFT(P.Event, 2)) = 1 AND CAST(LEFT(P.Event, 2) AS INT) > 75)	OR (P.Event LIKE '%+G%' AND ISNUMERIC(LEFT(P.Event, 2)) = 1 AND ISNUMERIC(SUBSTRING(P.Event, 4, 1)) = 1		AND CAST(LEFT(P.Event, 2) AS INT) + CAST(SUBSTRING(P.Event, 4, 1) AS INT) > 75)GROUP BY M.Year	, CASE 		WHEN P.Team_Initials = M.Home_Team_Initials THEN M.Home_Team_Name		ELSE M.Away_Team_Name	  ENDORDER BY COUNT(P.Event) DESCOFFSET 0 ROWSFETCH NEXT 1 ROWS ONLY;-- Business scenario Q109 - Top Scorer of 2018SELECT P.Player_Name AS Player	, COUNT(P.Event) AS GoalsScoredFROM WC.WorldCupPlayers PINNER JOIN WC.WorldCupMatches M ON P.MatchID = M.MatchIDWHERE M.Year = 2010 AND P.Event LIKE '%G%' GROUP BY P.Player_NameORDER BY  COUNT(P.Event) DESCOFFSET 0 ROWSFETCH NEXT 1 ROWS ONLY;-- Business scenario Q110 - Host PerformanceSELECT W.Country AS HostCountry	, SUM(CASE			WHEN M.Home_Team_Name = W.Country AND M.Home_Team_Goals > M.Away_Team_Goals THEN 1			WHEN M.Away_Team_Name = W.Country AND M.Away_Team_Goals > M.Home_Team_Goals THEN 1			ELSE 0		 END) AS MatchesWon	, SUM(CASE WHEN M.Home_Team_Goals = M.Away_Team_Goals THEN 1 ELSE 0 END) AS MatchesDrawn	, SUM(CASE			WHEN M.Home_Team_Name = W.Country AND M.Home_Team_Goals < M.Away_Team_Goals THEN 1			WHEN M.Away_Team_Name = W.Country AND M.Away_Team_Goals < M.Home_Team_Goals THEN 1			ELSE 0		 END) AS MatchesLostFROM WC.WorldCups WINNER JOIN WC.WorldCupMatches M ON W.Year = M.YearWHERE W.Year = (SELECT MAX(W.Year)				FROM WC.WorldCups W				)	AND (M.Home_Team_Name = W.Country OR M.Away_Team_Name = W.Country)GROUP BY W.Country;