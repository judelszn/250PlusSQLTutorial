USE TwitterDB;

-- Scenario Q17 - Identify Users Who Have Not Retweeted Any Tweets
SELECT U.UserID
	, U.Username
	, U.FullName
FROM Twitter.Users U
WHERE U.UserID NOT IN (SELECT R.UserID
					FROM Twitter.Retweets R
					)
;

-- OR
SELECT U.UserID
	, U.Username
	, U.FullName
FROM Twitter.Users U
LEFT JOIN Twitter.Retweets R ON U.UserID = R.UserID
WHERE R.RetweetID IS NULL
;



-- Scenario Q18 - Analyse Engagement Metrics of Mentioned Users