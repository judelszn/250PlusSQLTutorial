USE TwitterDB;

-- Scenario Q11 - Identify Users Who Have Not Engaged Recently
SELECT U.UserID
    , U.Username
    , U.FullName
FROM Twitter.Users U
WHERE NOT EXISTS (SELECT 1
                  FROM Twitter.DirectMessages D
                  WHERE D.SenderID = U.UserID
                  AND D.Timestamp >= DATEADD(DAY,-30, GETDATE()))
AND NOT EXISTS (SELECT 1 
                FROM Twitter.Tweets T
                WHERE T.UserID = U.UserID
                  AND T.Timestamp >= DATEADD(DAY,-30, GETDATE()))                  
;



-- Scenario Q12 - Find Most Popular Tweets Based on User Interaction
SELECT T.TweetID
    , T.TweetText
    , U.UserID
    , U.Username
    , U.FullName
    , ISNULL(COUNT(L.TweetID), 0) + ISNULL(COUNT(R.RetweetID), 0) + ISNULL(COUNT(M.TweetID), 0)
        AS TotalInteractions
FROM Twitter.Tweets T
INNER JOIN Twitter.Users U ON T.UserID = U.UserID
LEFT JOIN Twitter.Likes L ON T.TweetID = L.TweetID
LEFT JOIN Twitter.Retweets R ON T.TweetID = R.OriginalTweetID
LEFT JOIN Twitter.Mentions M ON T.TweetID = M.TweetID
GROUP BY T.TweetID, T.TweetText, U.UserID, U.Username, U.FullName
ORDER BY TotalInteractions DESC
OFFSET 0 ROWS
FETCH NEXT 3 ROWS ONLY
;