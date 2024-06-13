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



-- Scenario Q18 - Analyse Engagement Metrics of Mentioned UsersWITH MentionedUsers AS (	SELECT M.MentionedUserID AS UserID	, COUNT(*) AS MentionCount	FROM Twitter.Mentions M	GROUP BY M.MentionedUserID	ORDER BY COUNT(*) DESC	OFFSET 0 ROWS	FETCH NEXT 5 ROWS ONLY	)SELECT MU.UserID	, U.Username	, U.FullName	, MU.MentionCount	, AVG(LK.LikeCount) AS AverageLikes	, AVG(RT.RetweetCount) AS AverageRetweetsFROM MentionedUsers MUINNER JOIN Twitter.Users U ON MU.UserID = U.UserIDLEFT JOIN (	SELECT L.UserID		, COUNT(*) AS LikeCount	FROM Twitter.Likes L	GROUP BY L.UserID	) LK ON LK.UserID = MU.UserIDLEFT JOIN (	SELECT R.UserID		, COUNT(*) AS RetweetCount	FROM Twitter.Retweets R	GROUP BY R.UserID	) RT ON RT.UserID = MU.UserIDGROUP BY MU.UserID, U.Username, U.FullName, MU.MentionCountORDER BY MU.MentionCount DESC;