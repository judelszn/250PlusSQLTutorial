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
	LEFT JOIN (SELECT TweetID, COUNT(*) AS LikeCount FROM Twitter.Likes GROUP BY TweetID) LK1 ON T.TweetID = LK.TweetID
	LEFT JOIN (SELECT R.UserID, COUNT(*) AS RetweetCount FROM Twitter.Retweets R GROUP BY R.UserID) RT ON T.UserID = RT.UserID
	GROUP BY T.UserID
	)
SELECT UE.UserID
	, UE.Username
	, UE.FullName
	, UE.EngagementScore
	, TV.AverageLikes
	, TV.AverageRetweets
 FROM UserEngagement UE
 JOIN TweetVisibility TV ON UE.UserID = TV.UserID
 ORDER BY UE.EngagementScore DESC, TV.AverageLikes ASC, TV.AverageRetweets ASC
 OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
;

WITH UserEngagement AS (
    SELECT
        u.UserID,
        u.Username,
        u.FullName,
        (COUNT(DISTINCT dm.MessageID) +
         COUNT(DISTINCT l.LikeID) +
         COUNT(DISTINCT r.RetweetID) +
         COUNT(DISTINCT m.MentionID)) as EngagementScore
    FROM Twitter.Users u
    LEFT JOIN Twitter.DirectMessages dm ON u.UserID = dm.SenderID
    LEFT JOIN Twitter.Likes l ON u.UserID = l.UserID
	 LEFT JOIN Twitter.Retweets r ON u.UserID = r.UserID
    LEFT JOIN Twitter.Mentions m ON u.UserID = m.MentionedUserID
    GROUP BY u.UserID, u.Username, u.FullName
 ),
 TweetVisibility AS (
    SELECT
        t.UserID,
        AVG(CAST(COALESCE(lk.LikeCount, 0) as FLOAT)) as AverageLikes,
        AVG(CAST(COALESCE(rt.RetweetCount, 0) as FLOAT)) as AverageRetweets
    FROM Twitter.Tweets t
    LEFT JOIN (SELECT TweetID, COUNT(*) as LikeCount FROM Twitter.Likes GROUP BY 
TweetID) lk ON t.TweetID = lk.TweetID
    LEFT JOIN (SELECT UserID, COUNT(*) as RetweetCount FROM Twitter.Retweets GROUP 
BY UserID) rt ON t.TweetID = rt.UserID
    GROUP BY t.UserID
 )
 SELECT
    ue.UserID,
    ue.Username,
    ue.FullName,
    ue.EngagementScore,
    tv.AverageLikes,
    tv.AverageRetweets
 FROM UserEngagement ue
 JOIN TweetVisibility tv ON ue.UserID = tv.UserID
 ORDER BY ue.EngagementScore DESC, tv.AverageLikes ASC, tv.AverageRetweets ASC
 OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;





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