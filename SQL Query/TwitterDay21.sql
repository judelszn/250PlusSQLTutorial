USE TwitterDB;

-- Scenario Q41 - Identify Users Mentioned in Tweets but Not Following the Tweeter
WITH NonFollowingMentions AS (
	SELECT M.MentionedUserID
		, T.UserID AS TweeterUserID
	FROM Twitter.Mentions M
	INNER JOIN Twitter.Tweets T ON M.TweetID = T.TweetID
	LEFT JOIN Twitter.Followers F ON F.FollowedUserID = M.MentionedUserID
		AND F.FollowedUserID = T.UserID
	WHERE F.FollowedUserID IS NULL
	)
SELECT NM.MentionedUserID
	, U.Username
	, U.FullName
	, COUNT(*) AS MentionCount
FROM NonFollowingMentions NM
INNER JOIN Twitter.Users U ON NM.MentionedUserID = U.UserID
GROUP BY NM.MentionedUserID, U.Username, U.FullName
ORDER BY COUNT(*) DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY
;



-- Scenario Q42 - Identify the Most Retweeted Original Tweets
WITH OriginalTweetRetweets AS (
	SELECT R.OriginalTweetID
		, T.UserID
		, COUNT(*) AS RetweetCount
	FROM Twitter.Retweets R
	INNER JOIN Twitter.Tweets T ON R.OriginalTweetID = T.TweetID
	GROUP BY R.OriginalTweetID, T.UserID
	)
SELECT OTR.OriginalTweetID
	, OTR.UserID
	, U.UserID
	, U.FullName
	, T.TweetText
	, OTR.RetweetCount
FROM OriginalTweetRetweets OTR
INNER JOIN Twitter.Users U ON OTR.UserID = U.UserID
INNER JOIN Twitter.Tweets T ON OTR.OriginalTweetID = T.TweetID
ORDER BY OTR.RetweetCount DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY
;