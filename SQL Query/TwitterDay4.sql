USE TwitterDB;

-- Scenario Q7 - Identify Influential Users and Their Impact on User Engagement
WITH InfluentialUsers AS (
	SELECT U.UserID
		, U.Username
		, U.FullName
		, COUNT(F.FollowerUserID) AS FollowersCount
	FROM Twitter.Users U
	INNER JOIN Twitter.Followers F ON U.UserID = F.FollowedUserID
	GROUP BY U.UserID, U.Username, U.FullName
	ORDER BY COUNT(F.FollowerUserID) DESC
	OFFSET 0 ROWS
	FETCH NEXT 5 ROWS ONLY
	)
SELECT IU.UserID
	, IU.Username
	, IU.FullName
	, IU.FollowersCount
	, ISNULL(DM.MessageCount, 0) AS MessagesCount
	, ISNULL(LK.LikeCount, 0) AS LikesCount
	, ISNULL(MT.MentionCount, 0) AS MentionsCount
	, ISNULL(NT.NotificationCount, 0) AS NotificationsCount
	, ISNULL(RT.RetweetCount, 0) AS RetweetsCount
FROM InfluentialUsers IU
LEFT JOIN (SELECT D.SenderID
				, COUNT(*) AS MessageCount
			FROM Twitter.DirectMessages D
			GROUP BY D.SenderID
			) AS DM ON IU.UserID = DM.SenderID
LEFT JOIN (SELECT L.UserID
				, COUNT(*) AS LikeCount
			FROM Twitter.Likes L
			GROUP BY L.UserID
			) AS LK ON IU.UserID = LK.UserID
LEFT JOIN (SELECT M.MentionedUserID
				, COUNT(*) AS MentionCount 
			FROM Twitter.Mentions M
			GROUP BY M.MentionedUserID
			) AS MT ON IU.UserID = MT.MentionedUserID
LEFT JOIN (SELECT N.UserID
				, COUNT(*) AS NotificationCount
			FROM Twitter.Notifications N
			GROUP BY N.UserID
			) AS NT ON IU.UserID = NT.UserID
LEFT JOIN (SELECT R.UserID
				, COUNT(*) AS RetweetCount
			FROM Twitter.Retweets R
			GROUP BY R.UserID
			) AS RT ON IU.UserID = RT.UserID
ORDER BY IU.FollowersCount DESC
;



-- Scenario Q8 - Track User Retention and Platform Engagement Over Time
-- Task 1 - User retension analysis
WITH RecentActiveUsers AS (
	SELECT U.UserID
		, U.Username
		, U.FullName
		, U.JoinDate
	FROM Twitter.Users U
	WHERE U.JoinDate >= DATEADD(YEAR, -1, GETDATE())
	AND (EXISTS (SELECT 1
					FROM Twitter.DirectMessages D
					WHERE D.Timestamp >= DATEADD(MONTH, -1, GETDATE())
				)
		)
	)
-- Task 2 Engagemnet Analysis
SELECT RU.UserID
	, RU.Username
	, RU.FullName
	, RU.JoinDate
	, ISNULL(DM.MessageCount, 0) AS MessagesCount
	, ISNULL(LK.LikeCount, 0) AS LikesCount
	, ISNULL(MT.MentionCount, 0) AS MentionsCount
	, ISNULL(RT.RetweetCount, 0) AS RetweetsCount
FROM RecentActiveUsers RU
LEFT JOIN (SELECT D.SenderID
				, COUNT(*) AS MessageCount
			FROM Twitter.DirectMessages D
			GROUP BY D.SenderID
			) AS DM ON RU.UserID = DM.SenderID
LEFT JOIN (SELECT L.UserID
				, COUNT(*) AS LikeCount
			FROM Twitter.Likes L
			GROUP BY L.UserID
			) AS LK ON RU.UserID = LK.UserID
LEFT JOIN (SELECT M.MentionedUserID
				, COUNT(*) AS MentionCount 
			FROM Twitter.Mentions M
			GROUP BY M.MentionedUserID
			) AS MT ON RU.UserID = MT.MentionedUserID
LEFT JOIN (SELECT R.UserID
				, COUNT(*) AS RetweetCount
			FROM Twitter.Retweets R
			GROUP BY R.UserID
			) AS RT ON RU.UserID = RT.UserID
ORDER BY RU.JoinDate ASC
;