-- Business scenario Q46 - Top Scorers by Match Phase
USE SOCCER_DB;
WITH GoalPhase AS (
	SELECT G.player_id
		, CASE
			WHEN G.goal_time <= 90 THEN 'Regular Time'
			WHEN G.goal_time > 90 AND G.goal_time <= 120 THEN 'Extra Time'
			ELSE 'Penalty Shootout'
		  END AS MatchPhase
		, COUNT(G.goal_id) AS GoalsScored
	FROM dbo.goal_details G
	GROUP BY G.player_id,
		CASE
			WHEN G.goal_time <= 90 THEN 'Regular Time'
			WHEN G.goal_time > 90 AND G.goal_time <= 120 THEN 'Extra Time'
			ELSE 'Penalty Shootout'
		  END
	)
SELECT P.player_name AS PlayerName
	, GP.MatchPhase
	, GP.GoalsScored
FROM GoalPhase GP
INNER JOIN dbo.player_mast P ON GP.player_id = P.player_id
ORDER BY GP.MatchPhase, GP.GoalsScored DESC
;


-- Business scenario Q47 - Most Utilised Substitutes
SELECT P.player_name AS PlayerName
	, COUNT(*) AS SubstitutionsCount
FROM dbo.player_in_out OI
INNER JOIN dbo.player_mast P ON OI.player_id = P.player_id
GROUP BY P.player_name
ORDER BY COUNT(*) DESC
;


-- Business scenario Q48 - Player Performance by Bookings and GoalsSELECT *FROM dbo.goal_details GINNER JOIN dbo.player_booked B ;-- Business scenario Q49 - Matches with the Most BookingsSELECT M.match_no	, COUNT(*) AS BookingsCountFROM dbo.match_mast MINNER JOIN dbo.player_booked B ON M.match_no = B.match_noGROUP BY M.match_noORDER BY COUNT(*) DESC;-- Business scenario Q50 - Venue with the Highest Average Goals per MatchSELECT V.venue_name AS VenueName	, AVG(G.goal_id) AS AverageGoalsFROM dbo.match_mast MINNER JOIN dbo.goal_details G ON M.match_no = G.match_noINNER JOIN dbo.soccer_venue V ON V.venue_id = V.venue_idGROUP BY V.venue_nameORDER BY AVG(G.goal_id) DESC;