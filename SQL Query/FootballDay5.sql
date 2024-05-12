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


-- Business scenario Q22 - Spot-kick ShotsSELECT COUNT(*) AS PenaltyShotsCountFROM dbo.penalty_shootout P;-- Business scenario Q23 - Successful Penalty ShotsSELECT COUNT(*) GoalsScoredCountFROM dbo.penalty_shootout PSWHERE PS.score_goal = 'Y' AND PS.match_no IN (	SELECT M.match_no	FROM dbo.match_mast M	WHERE M.play_date LIKE '2016%'	);-- Business scenario Q24 - Missed or Saved Penalty Shots
SELECT COUNT(*) ShotsMissedOrSavedCountFROM dbo.penalty_shootout PSWHERE PS.score_goal = 'N' AND PS.match_no IN (	SELECT M.match_no	FROM dbo.match_mast M	WHERE M.play_date LIKE '2016%'	);-- Business scenario Q25 - Players in Penalty ShootoutsSELECT P.player_name AS Player	, C.country_name	, COUNT(S.player_id) AS ShotsTakenFROM dbo.player_mast PINNER JOIN dbo.soccer_country C ON P.team_id = C.country_idLEFT JOIN dbo.penalty_shootout S ON P.player_id = S.player_idGROUP BY P.player_id, P.player_name, C.country_nameHAVING COUNT(S.player_id) > 0ORDER BY COUNT(S.player_id) DESC, P.player_name;