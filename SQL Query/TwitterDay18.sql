USE TwitterDB;

-- Scenario Q35 - Identify Users Mentioned by the Most Diverse User BaseSELECT M.MentionedUserID	, U.Username	, U.FullName	, COUNT(DISTINCT M.MentionID) AS UniqueMentionsCountFROM Twitter.Users UINNER JOIN Twitter.Mentions M ON U.UserID = M.MentionedUserIDGROUP BY M.MentionedUserID, U.Username, U.FullNameORDER BY COUNT(DISTINCT M.MentionID) DESCOFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;-- Scenario Q36 - Identify Top Tweets with the Highest Engagement to Follower RatioWITH TweetEngagement AS (	SELECT T.TweetID		, T.UserID		, T.TweetText		, COALESCE(SUM(LK.LikeCount), 0) + COALESCE(SUM(RT.RetweetCount), 0) AS EngagementCount	FROM Twitter.Tweets T	LEFT JOIN (SELECT L.TweetID					, COUNT(*) AS LikeCount				FROM Twitter.Likes L				GROUP BY L.TweetID) LK ON T.TweetID = LK.TweetID	LEFT JOIN (SELECT R.UserID					, COUNT(*) AS RetweetCount				FROM Twitter.Retweets R				GROUP BY R.UserID) RT ON T.UserID = RT.UserID	GROUP BY T.TweetID, T.UserID, T.TweetText	),UserFollowerCount AS (	SELECT F.FollowedUserID AS UserID		, COUNT(*) AS FollowerCount	FROM Twitter.Followers F	GROUP BY F.FollowedUserID	)SELECT TE.TweetID	, TE.UserID	, U.Username	, U.FullName	, TE.TweetText	, TE.EngagementCount	, UC.FollowerCount	, CAST(TE.EngagementCount AS FLOAT) / UC.FollowerCount AS EngagementFollowerRatioFROM TweetEngagement TEINNER JOIN Twitter.Users U ON TE.UserID = U.UserIDINNER JOIN UserFollowerCount UC ON TE.UserID = UC.UserIDORDER BY EngagementFollowerRatio DESCOFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;