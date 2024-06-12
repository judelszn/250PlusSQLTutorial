USE TwitterDB;

-- Scenario Q15 - Identify Users with the Most Diverse Engagement
SELECT  U.UserID
	, U.Username
	, U.FullName
	, (CASE WHEN COUNT(DISTINCT D.MessageID) > 0 THEN 1 ELSE 0 END +
		CASE WHEN COUNT(DISTINCT L.LikeID) > 0 THEN 1 ELSE 0 END +
		CASE WHEN COUNT(DISTINCT R.RetweetID) > 0 THEN 1 ELSE 0 END +
		CASE WHEN COUNT(DISTINCT M.MentionID) > 0 THEN 1 ELSE 0 END 
		) AS ActivityCount
FROM Twitter.Users U
LEFT JOIN Twitter.DirectMessages D ON U.UserID = D.SenderID
LEFT JOIN Twitter.Likes L ON U.UserID = L.UserID
LEFT JOIN Twitter.Retweets R ON U.UserID = R.UserID
LEFT JOIN Twitter.Mentions M ON U.UserID = M.MentionedUserID
GROUP BY U.UserID, U.Username, U.FullName
ORDER BY ActivityCount DESC
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY
;



-- Scenario Q16 - Identify Most Active Users in Direct Messaging
SELECT U.UserID
	, U.Username
	, U.FullName
	, COUNT(*) AS MessageSentCount
FROM Twitter.Users U
INNER JOIN Twitter.DirectMessages D ON U.UserID = D.SenderID
GROUP BY U.UserID, U.Username, U.FullName
ORDER BY COUNT(*) DESC
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY
;