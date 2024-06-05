USE TwitterDB;

-- Scenario Q1 - Analysis of most active users
SELECT U.UserID
	, U.Username
	, U.FullName
	, (ISNULL(DM.MessageCount, 0) + ISNULL(LK.LikesCount, 0) + ISNULL(MT.MentionsCount, 0) + 
		ISNULL(RT.RetweetsCount, 0) + ISNULL(NT.NotificationsCount, 0)) AS TotalEngagement
FROM Twitter.Users U
LEFT JOIN (SELECT D.SenderID
				, COUNT(*) AS MessageCount
			FROM Twitter.DirectMessages D
			GROUP BY D.SenderID 
			) DM ON U.UserID = DM.SenderID
LEFT JOIN (SELECT L.UserID
				, COUNT(*) AS LikesCount
			FROM Twitter.Likes L
			GROUP BY L.UserID) LK ON U.UserID = LK.UserID
LEFT JOIN (SELECT M.UserID
				, COUNT(*) AS MentionsCount
			FROM Twitter.Mentions M
			GROUP BY M.UserID) MT ON U.UserID = MT.UserID
LEFT JOIN (SELECT R.UserID
				, COUNT(*) AS RetweetsCount
			FROM Twitter.Retweets R
			GROUP BY R.UserID
			) RT ON U.UserID = RT.UserID
LEFT JOIN (SELECT N.UserID
				, COUNT(*) AS NotificationsCount
			FROM Twitter.Notifications N
			GROUP BY N.UserID
			) NT ON U.UserID = NT.UserID
ORDER BY TotalEngagement DESC
;