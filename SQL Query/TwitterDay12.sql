USE TwitterDB;

-- Scenario Q23 - Identify Users Who Like Their Own Tweets
SELECT U.UserID
	, U.Username
	, U.FullName
FROM Twitter.Users U
INNER JOIN Twitter.Tweets T ON U.UserID = T.UserID
INNER JOIN Twitter.Likes L ON U.UserID = L.UserID AND T.TweetID = L.TweetID
;



-- Scenario Q24 - Identify Users Who Retweet but Don’t Tweet
SELECT U.UserID
	, U.Username
	, U.FullName
FROM Twitter.Users U 
INNER JOIN Twitter.Retweets R ON U.UserID = R.UserID
WHERE NOT EXISTS (SELECT 1
					FROM Twitter.Tweets T
					WHERE T.UserID = U.UserID)
;