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



-- Business scenario Q108 - Late Bloomers