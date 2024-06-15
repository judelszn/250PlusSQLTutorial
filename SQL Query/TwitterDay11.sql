USE TwitterDB;

-- . Scenario Q21 - Identify Active Users Not Following Back
WITH ActiveUsers AS (
	SELECT T.UserID
		, COUNT(*) AS TweetCount
	FROM Twitter.Tweets T
	GROUP BY T.UserID
	),
NonFollowBack AS (
	SELECT F.FollowedUserID AS UserID
		, COUNT(*) AS NonFollowBackCount
	FROM Twitter.Followers F
	WHERE NOT EXISTS (SELECT 1
						FROM Twitter.Followers F2
						WHERE F2.FollowedUserID = F.FollowerUserID
						AND F2.FollowedUserID = F.FollowerUserID)
	GROUP BY F.FollowedUserID
	)
SELECT AU.UserID
	, U.Username
	, U.FullName
	, AU.TweetCount
	, NB.NonFollowBackCount
FROM ActiveUsers AU
INNER JOIN Twitter.Users U ON AU.UserID = U.UserID
INNER JOIN NonFollowBack NB ON AU.UserID = NB.UserID
ORDER BY AU.TweetCount DESC, NB.NonFollowBackCount DESC
OFFSET 0 ROWS 
FETCH NEXT 3 ROWS ONLY
;



-- Scenario Q22 - Identify Potential Brand Ambassadors
WITH TwitterMentions AS (
	SELECT T.UserID
		, COUNT(*) AS TwitterMentionsCount
	FROM Twitter.Tweets T
	WHERE LOWER(T.TweetText) LIKE '%twitter%'
	GROUP BY T.UserID
	),
UserFollowers AS (
	SELECT F.FollowedUserID AS UserID
		, COUNT(*) AS FollowersCount
	FROM Twitter.Followers F
	GROUP BY F.FollowedUserID
	)
SELECT TM.UserID
	, U.Username
	, U.FullName
	, TM.TwitterMentionsCount
	, UF.FollowersCount
FROM TwitterMentions TM
INNER JOIN UserFollowers UF ON TM.UserID = UF.UserID
INNER JOIN Twitter.Users U ON TM.UserID = U.UserID
ORDER BY TM.TwitterMentionsCount DESC, UF.FollowersCount DESC
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY
;