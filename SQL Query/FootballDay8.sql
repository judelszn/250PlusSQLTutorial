-- Business scenario Q36 - Referee Analysis
USE SOCCER_DB;
SELECT R.referee_name AS RefereeName
	, COUNT(M.match_no) AS MatchOfficiatedCount
FROM dbo.match_mast M
INNER JOIN dbo.referee_mast R ON M.referee_id = R.referee_id
GROUP BY R.referee_name
ORDER BY COUNT(M.referee_id) DESC
;


-- Business scenario Q37 - Top Goal Scorers
SELECT TOP 5 P.player_name AS PlayerName
	, COUNT(G.goal_id) AS GoalCount
FROM dbo.goal_details G
INNER JOIN dbo.player_mast P ON G.player_id = P.player_id
GROUP BY P.player_name 
ORDER BY COUNT(G.goal_id) DESC
;


-- Business scenario Q38 - Teams with Most Bookings
SELECT TOP 3 C.country_name AS CountryName
	, COUNT(B.player_id) AS BookingCount
FROM dbo.player_booked B
INNER JOIN dbo.soccer_country C ON B.team_id = C.country_id
GROUP BY C.country_name
ORDER BY COUNT(B.player_id) DESC
;


-- Business scenario Q39 - Players substituted the Most
SELECT PM.player_name AS PlayerName
	, COUNT(PT.player_id) AS SubstitutionCount
FROM dbo.player_in_out PT
INNER JOIN dbo.player_mast PM ON PT.player_id = PM.player_id
WHERE PT.in_out = 'O'
GROUP BY PM.player_name
ORDER BY COUNT(PT.player_id) DESC
;


-- Business scenario Q40 - Referees who Officiated Most Matches 
SELECT R.referee_name AS RefereeName
	, COUNT(M.match_no) AS MatchOfficiatedCount
FROM dbo.match_mast M
INNER JOIN dbo.referee_mast R ON M.referee_id = R.referee_id
WHERE M.play_date LIKE '2016%'
GROUP BY R.referee_name
ORDER BY COUNT(M.match_no) DESC
;