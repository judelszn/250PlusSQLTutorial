USE TwitterDB;

-- Scenario Q27 - Identify Users Who Received Likes from Users They Don't Follow
SELECT T.UserID
	, U.Username
	, U.FullName
	, COUNT(*) AS LikesReceived
FROM Twitter.Tweets T
INNER JOIN Twitter.Users U ON T.UserID = U.UserID
INNER JOIN Twitter.Likes L ON T.TweetID = L.TweetID
LEFT JOIN Twitter.Followers F ON T.UserID = F.FollowedUserID AND L.UserID = F.FollowerUserID
WHERE F.FollowerUserID IS NULL
GROUP BY T.UserID, U.Username, U.FullName
ORDER BY COUNT(*) DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY
;



-- Scenario Q28 - Identify Users Who Are Frequently Retweeted but Don't Retweet Others
WITH UserRetweets AS (
	SELECT T.UserID
		, COUNT(*) AS RetweetCount
	FROM Twitter.Tweets T
	INNER JOIN Twitter.Retweets R ON T.UserID = R.UserID
	GROUP BY T.UserID
	)
SELECT UR.UserID
	, U.Username
	, U.FullName
	, UR.RetweetCount
FROM UserRetweets UR 
INNER JOIN Twitter.Users U ON UR.UserID = U.UserID
WHERE NOT EXISTS (SELECT 1
					FROM Twitter.Retweets R
					WHERE R.UserID = UR.UserID
					)
ORDER BY UR.RetweetCount DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY
;