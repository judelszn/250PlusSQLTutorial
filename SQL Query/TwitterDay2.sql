USE TwitterDB;

-- Scenario Q3 - Identify Users with Unread Notifications
SELECT U.UserID
	, U.Username
	, U.FullName
	, SUM(CASE WHEN N.IsRead = 0 THEN 1 ELSE 0 END) AS UnreadNotificationsCount 
FROM Twitter.Notifications N
INNER JOIN Twitter.Users U ON N.UserID = U.UserID
GROUP BY U.UserID, U.Username, U.FullName
ORDER BY UnreadNotificationsCount DESC
;



-- Scenario Q4 - Identify Most Liked Tweets
SELECT T.TweetID
	, T.TweetText
	, U.UserID
	, U.Username
	, U.FullName
	, COUNT(L.LikeID) AS LikesCount
FROM Twitter.Tweets T
INNER JOIN Twitter.Users U ON T.UserID = U.UserID
INNER JOIN Twitter.Likes L ON T.TweetID = L.TweetID
GROUP BY T.TweetID, T.TweetText, U.UserID, U.Username, U.FullName
ORDER BY COUNT(L.LikeID) DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY
;