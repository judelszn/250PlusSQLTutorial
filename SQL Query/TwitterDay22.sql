USE TwitterDB;

-- Scenario Q43 - Identify Tweets that Generated the Most User Engagement Across Various Types
WITH TwitterEngagement AS (
	SELECT T.TweetID
	, T.UserID
	, COUNT(DISTINCT L.UserID) + COUNT(DISTINCT M.UserID) + COUNT(DISTINCT R.UserID) AS TotalEngagement
	FROM Twitter.Tweets T 
	LEFT JOIN Twitter.Likes L ON T.TweetID = L.TweetID
	LEFT JOIN Twitter.Mentions M ON T.TweetID = M.TweetID
	LEFT JOIN Twitter.Retweets R ON T.TweetID = R.OriginalTweetID
	GROUP BY T.TweetID, T.UserID
	)
SELECT TE.TweetID
	, TE.UserID
	, U.Username
	, U.FullName
	, T.TweetText
	, TE.TotalEngagement
FROM TwitterEngagement TE
INNER JOIN Twitter.Users U ON TE.UserID = U.UserID
INNER JOIN Twitter.Tweets T ON TE.TweetID = T.TweetID
ORDER BY TE.TotalEngagement DESC
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY
;



-- Scenario Q44 Find Users Who Received the Most Mentions in Tweets from Diverse Users
WITH DiverseMentions AS (
	SELECT M.MentionedUserID
		, COUNT(DISTINCT T.UserID) AS DiverseMentionsCount
	FROM Twitter.Mentions M
	INNER JOIN Twitter.Tweets T ON M.TweetID = T.TweetID
	GROUP BY M.MentionedUserID
	)
SELECT DM.MentionedUserID
	, U.Username
	, U.FullName
	, DM.DiverseMentionsCount
FROM DiverseMentions DM
INNER JOIN Twitter.Users U ON DM.MentionedUserID = U.UserID
ORDER BY DM.DiverseMentionsCount DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY
;