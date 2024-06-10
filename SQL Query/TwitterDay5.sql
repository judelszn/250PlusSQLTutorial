USE TwitterDB;

-- Scenario Q9 - Analyse the Most Common Type of User Notifications
SELECT N.NotificationType
    , COUNT(*) AS NotificationsCount
FROM Twitter.Notifications N
GROUP BY N.NotificationType
ORDER BY COUNT(*) DESC
;



-- Scenario Q10 - Discover Users with High Engagement but Low Follower Count
WITH UserMessageCount AS (
    SELECT TOP 5 D.SenderID AS UserID
        , COUNT(*) AS MessageCount
    FROM Twitter.DirectMessages D
    GROUP BY D.SenderID
    ORDER BY COUNT(*) DESC
    )
SELECT UC.UserID
    , U.Username
    , U.FullName
    , UC.MessageCount
    , COUNT(F.FollowerUserID) AS FollowersCount
FROM UserMessageCount UC
INNER JOIN Twitter. Users U ON UC.UserID = U.UserID
LEFT JOIN Twitter.Followers F ON U.UserID = F.FollowedUserID
GROUP BY UC.UserID, U.Username, U.FullName, UC.MessageCount
HAVING COUNT(F.FollowerUserID) < 100
ORDER BY UC.MessageCount DESC   
;