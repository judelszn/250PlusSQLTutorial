USE TwitterDB;

-- Scenario Q29 - Identify Users Who Have the Most Followers but Follow the Fewest Users
WITH FollowerCount AS (
	SELECT F.FollowedUserID AS UserID
		, COUNT(*) AS FollowersCount
	FROM Twitter.Followers F
	GROUP BY F.FollowedUserID
	),
FollowingCount AS (
	SELECT F.FollowerUserID AS UserID
		, COUNT(*) AS FollowingsCount
	FROM Twitter.Followers F
	GROUP BY F.FollowerUserID
	)
SELECT U.UserID
	, U.Username
	, U.FullName
	, FC.FollowersCount
	, COALESCE(FT.FollowingsCount, 0) AS FollowingsCount
FROM Twitter.Users U
INNER JOIN FollowerCount FC ON U.UserID = FC.UserID
LEFT JOIN FollowingCount FT ON U.UserID = FT.UserID
ORDER BY FC.FollowersCount DESC, FT.FollowingsCount ASC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY
;



-- Scenario Q30 - Identify Users Who Have Liked but Never Been Liked
SELECT U.UserID
	, U.Username
	, U.FullName
FROM Twitter.Users U
INNER JOIN Twitter.Likes L ON U.UserID = L.UserID
WHERE NOT EXISTS (
	SELECT 1
	FROM Twitter.Tweets T
	INNER JOIN Twitter.Likes L ON T.TweetID = L.TweetID
	WHERE T.UserID = U.UserID
	)
GROUP BY U.UserID, U.Username, U.FullName
;