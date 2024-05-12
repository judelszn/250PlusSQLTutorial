-- Business scenario Q21 - Substitution Breakdown by Stage
USE SOCCER_DB;
SELECT P.play_schedule
	, COUNT(*) AS SubdtitutionCount
FROM dbo.player_in_out P
WHERE P.match_no IN (
	SELECT M.match_no
	FROM dbo.match_mast M
	WHERE M.play_date LIKE '2016%'
	)
GROUP BY P.play_schedule
ORDER BY COUNT(*) DESC
;


-- Business scenario Q22 - Spot-kick Shots
SELECT COUNT(*) ShotsMissedOrSavedCount