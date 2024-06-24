USE TwitterDB;

-- Scenario Q39 - Find Users Who Have Interacted the Most with Each Other
WITH UserInteraction AS (
	SELECT M.UserID AS UserID1
		, M.MentionedUserID AS UserID2
	FROM Twitter.Mentions M
	UNION ALL
	SELECT D.SenderID AS UserID1
		, D.ReceiverID AS UserID2
	FROM Twitter.DirectMessages D
	UNION ALL
	SELECT L.UserID AS UserID1
		, T.UserID AS UserID2
	FROM Twitter.Likes L
	INNER JOIN Twitter.Tweets T ON L.TweetID = T.TweetID
	UNION ALL
	SELECT R.UserID AS UserID1
		, T.UserID AS UserID2
	FROM Twitter.Retweets R
	INNER JOIN Twitter.Tweets T ON R.OriginalTweetID = T.TweetID
	)
SELECT UI.UserID1
	, U1.Username AS User1Username
	, U1.FullName AS User1FullName
	, UI.UserID2
	, U2.Username AS User2Username
	, U2.FullName AS User2FullName
	, COUNT(*) AS TotalInteractions
FROM UserInteraction UI
INNER JOIN Twitter.Users U1 ON UI.UserID1 = U1.UserID
INNER JOIN Twitter.Users U2 ON UI.UserID2 = U2.UserID
WHERE UI.UserID1 < UI.UserID2
GROUP BY UI.UserID1, U1.UserID, U1.Username, U1.FullName, UI.UserID2, U2.UserID, U2.Username, U2.FullName
ORDER BY COUNT(*) DESC
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY
;



-- Scenario Q40 - Identify the Most Active Users in Different Time Periods
WITH UserActivity AS (
	SELECT T.UserID
		, CASE 
			WHEN DATEPART(HOUR, T.Timestamp) BETWEEN 6 AND 12 THEN 'Morning'
			WHEN DATEPART(HOUR, T.Timestamp) BETWEEN 12 AND 18 THEN 'Afternoon'
			WHEN DATEPART(HOUR, T.Timestamp) BETWEEN 18 AND 24 THEN 'Evening'
			ELSE 'Night'
		  END AS TimePeriod
		, COUNT(*) AS TweetCount	  
	FROM Twitter.Tweets T
	GROUP BY T.UserID, DATEPART(HOUR, T.Timestamp)
	),
RankedUserActivity AS (
	SELECT UA.UserID
		, U.Username
		, U.FullName
		, UA.TimePeriod
		, UA.TweetCount
		, RANK() OVER(PARTITION BY UA.TimePeriod ORDER BY UA.TweetCount) AS Ranked
	FROM UserActivity UA 
	INNER JOIN Twitter.Users U ON UA.UserID = U.UserID
	)
SELECT RA.TimePeriod
	, RA.UserID
	, RA.Username
	, RA.FullName
	, RA.TweetCount
FROM RankedUserActivity RA
WHERE RA.Ranked = 1
;