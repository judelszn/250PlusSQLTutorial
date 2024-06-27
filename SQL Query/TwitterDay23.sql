USE TwitterDB;

-- Scenario Q45 - Identify Users Who Are Highly Active but Receive Low Engagement
WITH TweetEngagements AS (
	SELECT T.UserID
		, COUNT(DISTINCT T.TweetID) AS TotalTweets
		, AVG(COALESCE(LK.LikeCount, 0) + COALESCE(RT.RetweetCount, 0))
			AS AverageEngagementPerTweet
	FROM Twitter.Tweets T
	LEFT JOIN (SELECT L.TweetID
					, COUNT(*) AS LikeCount
				FROM Twitter.Likes L
				GROUP BY L.TweetID
				) LK ON T.TweetID = LK.TweetID
	LEFT JOIN (SELECT R.OriginalTweetID
					, COUNT(*) AS RetweetCount
				FROM Twitter.Retweets R
				GROUP BY R.OriginalTweetID
				) RT ON T.TweetID = RT.OriginalTweetID
	GROUP BY T.UserID
	) 
SELECT TE.UserID
	, U.Username
	, U.FullName
	, TE.TotalTweets
	, TE.AverageEngagementPerTweet
FROM TweetEngagements TE
INNER JOIN Twitter.Users U ON TE.UserID = U.UserID
ORDER BY TE.TotalTweets DESC, TE.AverageEngagementPerTweet ASC
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY
;



-- Scenario Q46 - Identify the Most Liked Tweets that Have Not Been Retweeted
WITH LikeEngagement AS (
	SELECT T.TweetID
		, T.UserID
		, COUNT(*) AS LikeCount
	FROM Twitter.Tweets T
	INNER JOIN Twitter.Likes L ON T.TweetID = L.TweetID
	GROUP BY T.TweetID, T.UserID
	),
RetweetEngagement AS (
	SELECT R.UserID
		, COUNT(*) AS RetweetCount
	FROM Twitter.Retweets R
	GROUP BY R.UserID
	)
SELECT LE.TweetID
	, LE.UserID
	, U.Username
	, U.FullName
	, T.TweetText
	, LE.LikeCount
FROM LikeEngagement LE
INNER JOIN Twitter.Users U ON LE.UserID = U.UserID
INNER JOIN Twitter.Tweets T ON LE.TweetID = T.TweetID
LEFT JOIN RetweetEngagement RE ON LE.TweetID = RE.UserID
WHERE RE.RetweetCount IS NULL OR RE.RetweetCount = 0
ORDER BY LE.LikeCount DESC
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY
;