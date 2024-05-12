-- Business scenario Q16 - Regular Play Substitutions
USE SOCCER_DB;
SELECT COUNT(*) SubsTitutionsNormalTimeCount
FROM dbo.player_in_out P
WHERE P.play_schedule = 'NT' AND P.in_out = 'I' 
AND P.match_no IN (
	SELECT M.match_no
	FROM dbo.match_mast M
	WHERE M.play_date LIKE '2016%'
	)
;


-- Business scenario Q17 - Stoppage Time Substitutions
SELECT COUNT(*) SubsTitutionsStoppageTimeCount
FROM dbo.player_in_out P
WHERE P.play_schedule = 'ST' AND P.in_out = 'I' 
AND P.match_no IN (
	SELECT M.match_no
	FROM dbo.match_mast M
	WHERE M.play_date LIKE '2016%'
	)
;


-- Business scenario Q18 - Analysing First-Half Substitution Patterns
SELECT COUNT(*) SubsTitutionsFirstHalfCount
FROM dbo.player_in_out P
WHERE P.play_half = 1 -- AND P.in_out = 'I' 
AND P.match_no IN (
	SELECT M.match_no
	FROM dbo.match_mast M
	WHERE M.play_date LIKE '2016%'
	)
;


-- Business scenario Q19 - Goalless Draws
SELECT COUNT(M.match_no) AS GoallessDrawMatchesCount
FROM DBO.match_mast M
WHERE M.play_date LIKE '2016%' AND M.results = 'DRAW' AND M.goal_score = '0-0'
;


-- Business scenario Q20 - Extra Time Substitutions
SELECT COUNT(*) SubsTitutionsExtraTimeCount
FROM dbo.player_in_out P
WHERE P.play_schedule = 'ET' AND P.in_out = 'I' 
AND P.match_no IN (
	SELECT M.match_no
	FROM dbo.match_mast M
	WHERE M.play_date LIKE '2016%'
	)
;