USE TwitterDB;

-- Scenario Q31 - Identify Most Engaged Users Across Multiple Interaction Types
WITH UserEngagements AS (
	SELECT AllInteractions.UserID
		, COUNT(*) AS EngagementScore
	FROM (
		SELECT D.SenderID AS UserID FROM Twitter.DirectMessages D
		UNION ALL 
		SELECT L.UserID FROM Twitter.Likes L
		UNION ALL
		SELECT R.UserID FROM Twitter.Retweets R
		UNION ALL 
		SELECT M.MentionedUserID AS UserID FROM Twitter.Mentions M
		) AS AllInteractions 
	GROUP BY AllInteractions.UserID
	) 
SELECT UE.UserID
	, U.Username
	, U.FullName
	, UE.EngagementScore
FROM UserEngagements UE
INNER JOIN Twitter.Users U ON UE.UserID = U.UserID
ORDER BY UE.EngagementScore DESC
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY
;



-- Scenario Q32 - Identify Users with Highest Difference Between Following and Followers
WITH FollowingCounts AS (
	SELECT F.FollowerUserID AS UserID
		, COUNT(*) AS FollowingCount
	FROM Twitter.Followers F
	GROUP BY F.FollowerUserID
	),
FollowerCounts AS (
	SELECT F.FollowedUserID AS UserID
		, COUNT(*) AS FollowerCount
	FROM Twitter.Followers F
	GROUP BY F.FollowedUserID
	)
SELECT U.UserID
	, U.Username
	, U.FullName
	, COALESCE(FC.FollowingCount, 0) AS FollowingCount
	, COALESCE(FR.FollowerCount, 0) AS FollowerCount
	, ABS(COALESCE(FC.FollowingCount, 0) - COALESCE(FR.FollowerCount, 0)) AS FollowingDifference
FROM Twitter.Users U
LEFT JOIN FollowingCounts FC ON U.UserID = FC.UserID
LEFT JOIN FollowerCounts FR ON U.UserID = FR.UserID
ORDER BY FollowingDifference DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY
;