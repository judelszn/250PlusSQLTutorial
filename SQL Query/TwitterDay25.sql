USE TwitterDB;

-- Scenario Q49 - Identify Most Frequently Mentioned Keywords in Tweets
SELECT Keyword
	, COUNT(*) AS MentionCount
FROM (SELECT VALUE AS Keyword
		FROM Twitter.Tweets T
		CROSS APPLY STRING_SPLIT(T.TweetText, ' ')
		) AS Keywords
WHERE LEN(Keyword) > 0
GROUP BY Keyword
ORDER BY MentionCount DESC
OFFSET 0 ROWS
FETCH NEXT 15 ROWS ONLY 
;



-- Scenario Q50 - Identify Users Who Haven’t Tweeted in the Last 6 months.
WITH UserLastTweet AS (
	SELECT T.UserID
		, MAX(T.Timestamp) AS LastTweetDate
	FROM Twitter.Tweets T
	GROUP BY T.UserID
	)
SELECT U.UserID
	, U.Username
	, U.FullName
	, UT.LastTweetDate
FROM Twitter.Users U
LEFT JOIN UserLastTweet UT ON U.UserID = UT.UserID
WHERE DATEDIFF(MONTH, ISNULL(UT.LastTweetDate, '19000101'), GETDATE()) > 12
AND UT.LastTweetDate IS NOT NULL
ORDER BY UT.LastTweetDate
;