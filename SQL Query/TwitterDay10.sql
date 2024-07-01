USE TwitterDB;

-- Scenario Q19 - Find Users with High Engagement but Low Tweet Visibility
WITH UserEngagement AS (
	SELECT U.UserID
		, U.Username
		, U.FullName
		, (COUNT(DISTINCT D.MessageID) + COUNT(DISTINCT L.LikeID) + COUNT(DISTINCT R.RetweetID) + COUNT(DISTINCT M.MentionID))
			AS EngagementScore
	FROM Twitter.Users U
	LEFT JOIN Twitter.DirectMessages D ON U.UserID = D.SenderID
	LEFT JOIN Twitter.Likes L ON U.UserID = L.UserID
	LEFT JOIN Twitter.Retweets R ON U.UserID = R.UserID
	LEFT JOIN Twitter.Mentions M ON U.UserID = M.MentionedUserID
	GROUP BY U.UserID, U.Username, U.FullName
	),
TweetVisibility AS (
	SELECT *
		, AVG(CAST(COALESCE(LK.LikeCount, 0), AS FLOAT)) AS AverageLikes
		, AVG(CAST(COALESCE(RT.RetweetCount, 0), AS FLOAT)) AS AverageRetweets
	FROM Twitter.Tweets T
	LEFT JOIN (SELECT L.TweetID
					, COUNT(*) AS LikeCount
				FROM Twitter.Likes L
				GROUP BY L.TweetID
				) LK ON T.TweetID = LK.TweetID
	LEFT JOIN (SELECT R.UserID
					, COUNT(*) AS RetweetCount
				FROM Twitter.Retweets R
				GROUP BY R.UserID
				) RT ON T.UserID = RT.UserID
	GROUP BY T.UserID
	)
SELECT * 
FROM 
;



-- Scenario Q20 - Find Users Who Have Received the Most Direct Messages
SELECT U.UserID
	, U.Username
	, U.FullName
	, COUNT(D.MessageID) AS ReceivedMessagesCount
FROM Twitter.Users U
INNER JOIN Twitter.DirectMessages D ON U.UserID = D.ReceiverID
GROUP BY U.UserID, U.Username, U.FullName
ORDER BY COUNT(D.MessageID) DESC
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY
;