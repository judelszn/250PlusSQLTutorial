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



-- Business scenario Q112 - First Time CharmSELECT M.Home_Team_Name AS Team	, M.Home_Team_Goals AS GoalsScored	, M.Year DebutYearFROM WC.WorldCupMatches MWHERE M.Year = (SELECT MIN(M.Year)				FROM WC.WorldCupMatches M				WHERE M.Home_Team_Name = M.Home_Team_Name				)UNION SELECT M.Away_Team_Name AS Team	, M.Home_Team_Goals AS GoalsScored	, M.Year DebutYearFROM WC.WorldCupMatches MWHERE M.Year = (SELECT MIN(M.Year)				FROM WC.WorldCupMatches M				WHERE M.Home_Team_Name = M.Home_Team_Name				)ORDER BY GoalsScored DESCOFFSET 0 ROWSFETCH NEXT 1 ROWS ONLY;-- Business scenario Q113 - Crowd PullersSELECT M.Home_Team_Name AS HomeTeam	, M.Away_Team_Name AS AwayTeam	, M.Year	, M.AttendanceFROM WC.WorldCupMatches MORDER BY M.Attendance DESCOFFSET 0 ROWSFETCH NEXT 1 ROWS ONLY;-- Business scenario Q114 - Rookie SensationWITH TeamDebuts AS (	SELECT M.Home_Team_Name AS Team		, MIN(M.Year) AS DebutYear	FROM WC.WorldCupMatches M	GROUP BY M.Home_Team_Name	UNION 	SELECT M.Away_Team_Name AS Team		, MIN(M.Year) AS DebutYear	FROM WC.WorldCupMatches M	GROUP BY M.Away_Team_Name	)SELECT TD.Team	, TD.DebutYearFROM TeamDebuts TDWHERE TD.DebutYear = (SELECT MAX(M.Year)						FROM WC.WorldCupMatches M);-- Business scenario Q115 - Swift RevengeSELECT M1.Home_Team_Name AS Team	, M1.Away_Team_Name AS Opponent	, M1.Year AS LossYear	, M2.Year AS WinYearFROM WC.WorldCupMatches M1JOIN WC.WorldCupMatches M2 ON M1.Home_Team_Name = M2.Home_Team_NameAND M1.Away_Team_Name = M2.Away_Team_NameAND M1.Year = M2.Away_Team_NameWHERE M1.Home_Team_Goals < M2.Away_Team_GoalsAND M2.Home_Team_Goals > M2.Away_Team_GoalsAND M2.Year > M1.YearORDER BY M1.YearOFFSET 0 ROWSFETCH NEXT 1 ROWS ONLY;