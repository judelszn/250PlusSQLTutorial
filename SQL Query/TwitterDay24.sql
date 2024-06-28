USE TwitterDB;

-- Scenario Q47  - Identify Most Engaged Followers 
WITH FollowerEngagements AS (
	SELECT F.FollowedUserID
		, F.FollowerUserID
		, COUNT(DISTINCT L.LikeID) + COUNT(DISTINCT R.UserID) AS TotalEngagement
	FROM Twitter.Followers F
	LEFT JOIN Twitter.Tweets T ON F.FollowedUserID = T.UserID
	LEFT JOIN Twitter.Likes L ON T.TweetID = L.TweetID AND L.UserID = F.FollowerUserID
	LEFT JOIN Twitter.Retweets R ON T.TweetID = R.OriginalTweetID AND R.UserID = F.FollowerUserID
	GROUP BY F.FollowedUserID, F.FollowerUserID
	),
RankedFolloweEngagement AS (
	SELECT FE.FollowedUserID
		, FE.FollowerUserID
		, U.Username AS FollowerUsername
		, U.FullName AS FollowerFullName
		, FE.TotalEngagement
		, RANK() OVER(PARTITION BY FE.FollowedUserID ORDER BY FE.TotalEngagement DESC) AS Ranked
	FROM FollowerEngagements FE
	INNER JOIN Twitter.Users U ON FE.FollowedUserID = U.UserID
	)
SELECT RE.FollowedUserID
	, RE.FollowerUserID
	, RE.FollowerUsername
	, RE.FollowerFullName
	, RE.TotalEngagement
FROM RankedFolloweEngagement RE
WHERE RE.Ranked <= 3
;



-- Scenario Q48  - Identify Users with High Follower to Following Ratio
WITH UserFollows AS (
	SELECT F.FollowerUserID
		, COUNT(DISTINCT F.FollowerUserID) AS FollowerCount
		, (SELECT COUNT(*)
			FROM Twitter.Followers F1
			WHERE F1.FollowerUserID = F.FollowerUserID) AS FollowingCount
	FROM Twitter.Followers F 
	GROUP BY F.FollowerUserID
	)
SELECT UF.FollowerUserID
	, U.UserID
	, U.Username
	, U.FullName
	, UF.FollowingCount
	, UF.FollowerCount
	, CAST(UF.FollowerCount AS FLOAT) / NULLIF(UF.FollowingCount, 0) AS FollowerFollowingRatio
FROM UserFollows UF
INNER JOIN Twitter.Users U ON UF.FollowerUserID = U.UserID
ORDER BY FollowerFollowingRatio DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY 
;