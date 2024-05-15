-- Business scenario Q31 - Player Discipline Analysis
USE SOCCER_DB;
SELECT M.player_name AS PlayerName
	, COUNT(B.player_id) AS BookingCount
FROM dbo.player_booked B
INNER JOIN dbo.player_mast M ON B.player_id = M.player_id
GROUP BY M.player_id, M.player_name
HAVING COUNT(B.player_id) > 1
ORDER BY COUNT(B.player_id) DESC
;


-- Business scenario Q32 - Coach Performance Analysis
SELECT CM.coach_name AS CoachName
FROM dbo.coach_mast CM
INNER JOIN dbo.Team_coaches TC ON CM.coach_id = TC.coach_id
WHERE TC.team_id IN (
	SELECT TOP 5 GD.team_id
	FROM dbo.goal_details GD
	GROUP BY GD.team_id
	ORDER BY COUNT(GD.goal_id) DESC)
;


-- Business scenario Q33 - Analysing Venue Utilisation
SELECT V.venue_name AS VenueName
	, COUNT(M.match_no) AS MatchesCount
FROM dbo.match_mast M
INNER JOIN dbo.soccer_venue V ON M.venue_id = V.venue_id
GROUP BY V.venue_name 
ORDER BY COUNT(M.match_no) DESC
;


-- Business scenario Q34 - Analysing Average Substitution Patterns
SELECT AVG(SubstitutionPerMatch.SubstitutionsCount) AS AverageSubstitutions
FROM (
	SELECT P.match_no
		, P.team_id
		, COUNT(P.player_id) AS SubstitutionsCount
	FROM dbo.player_in_out P
	WHERE P.play_half = 2
	GROUP BY P.match_no, P.team_id
	) AS SubstitutionPerMatch
;


-- Business scenario Q35 - Penalty Analysis
SELECT PS.team_id
	, (CAST(SUM(CASE WHEN PS.score_goal = 'Y' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) * 100 AS ConversionRate
FROM dbo.penalty_shootout PS
GROUP BY PS.team_id
ORDER BY ConversionRate DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
;