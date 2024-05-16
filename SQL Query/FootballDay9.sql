-- Business scenario Q41 - Teams with Highest Average Player Age
USE SOCCER_DB;
SELECT C.country_name AS CountryName
	, AVG(DATEDIFF(YEAR,P.dt_of_bir, '2016-06-10')) AS AverageAge
FROM dbo.player_mast P
INNER JOIN dbo.soccer_country C ON P.team_id = C.country_id
GROUP BY C.country_name
ORDER BY AVG(DATEDIFF(YEAR,P.dt_of_bir, '2016-06-10')) DESC
;


-- Business scenario Q42 - Stadiums with Highest Attendance
SELECT V.venue_name AS VenueName
	, SUM(M.audence) AS TotalAttendence
FROM dbo.match_mast M
INNER JOIN dbo.soccer_venue V ON M.venue_id = V.venue_id
GROUP BY V.venue_name
ORDER BY SUM(M.audence) DESC
;


-- Business scenario Q43 - Matches with Highest Number of Bookings 
SELECT B.match_no
	, COUNT(b.match_no) AS BookingsCount
FROM dbo.player_booked B
GROUP BY B.match_no
ORDER BY COUNT(b.match_no) DESC
;


-- Business scenario Q44 - Players who Played the Most Minutes
SELECT P.player_name AS PlayerName
, SUM(CASE
		WHEN OI.in_out = 'I' THEN 45
		WHEN OI.in_out = 'O' THEN 45
		ELSE 90
	  END 
		) AS TotalMinutesPlayed
FROM dbo.player_in_out OI
INNER JOIN dbo.player_mast P ON OI.player_id = P.player_id
GROUP BY P.player_name
ORDER BY TotalMinutesPlayed DESC
;


-- Business scenario Q45 - Top Venues by Number of Matches Hosteds
SELECT V.venue_name  AS VenueName
	, COUNT(*) AS MatchesHostedCount
FROM dbo.match_mast M
INNER JOIN dbo.soccer_venue V ON M.venue_id = V.venue_id
GROUP BY V.venue_name
ORDER BY COUNT(M.match_no) DESC
;