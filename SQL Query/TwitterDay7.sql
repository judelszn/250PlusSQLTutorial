USE TwitterDB;

-- Scenario Q13 - Find Users Who Have Never Been MentionedSELECT U.UserID	, U.Username	, U.FullNameFROM Twitter.Users UWHERE U.UserID NOT IN (SELECT M.MentionedUserID					FROM Twitter.Mentions M					)ORDER BY U.FullName ;-- ORSELECT U.UserID	, U.Username	, U.FullNameFROM Twitter.Users ULEFT JOIN Twitter.Mentions M ON U.UserID = M.MentionedUserIDWHERE M.MentionedUserID IS NULLORDER BY U.FullName ;-- Scenario Q14 - Analyse the Average Number of Followers per UserSELECT AVG(FollowerCounts.FollowCount) AS AverageFollowersPerUserFROM (SELECT F.FollowedUserID		, COUNT(*) AS FollowCount		FROM Twitter.Followers F		GROUP BY F.FollowedUserID		) AS FollowerCounts;