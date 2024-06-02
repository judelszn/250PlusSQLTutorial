USE WorldCup;

-- Business scenario Q111 - Stalemate Streak
SELECT CASE
			WHEN M.Home_Team_Goals = 0 THEN M.Home_Team_Name
			ELSE M.Away_Team_Name
		 END AS Team
	, COUNT(M.MatchID) AS GoallessDraws
FROM WC.WorldCupMatches M
INNER JOIN WC.WorldCups W ON M.Year = W.Year
WHERE M.Home_Team_Goals = 0 AND M.Away_Team_Goals = 0
GROUP BY CASE
			WHEN M.Home_Team_Goals = 0 THEN M.Home_Team_Name
			ELSE M.Away_Team_Name
		 END
ORDER BY COUNT(M.MatchID) DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY
;



-- Business scenario Q112 - First Time Charm