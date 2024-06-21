USE TwitterDB;

-- Scenario Q33 - Identify Users Who Like and Retweet Each Other’s Content the Most
WITH MutualLikes AS (
	SELECT L1.UserID AS UserID1
		, L2.UserID AS UserID2
		, COUNT(*) AS LikesCount
	FROM Twitter.Likes L1
	INNER JOIN Twitter.Likes L2 ON L1.TweetID = L2.TweetID AND L1.UserID <> L2.UserID
	GROUP BY L1.UserID, L2.UserID
	),
MutualRetweets AS (
	SELECT R1.UserID AS UserID1
		, R2.UserID AS UserID2
		, COUNT(*) AS RetweetsCount
	FROM Twitter.Retweets R1
	INNER JOIN Twitter.Retweets R2 ON R1.UserID = R2.UserID AND R1.UserID <> R2.UserID
	GROUP BY R1.UserID, R2.UserID
	)
SELECT U1.UserID AS UserID1
	, U1.Username AS Username1
	, U1.FullName AS Fullname1
	, U2.UserID AS UserID2
	, U2.Username AS Username2
	, U2.FullName AS Fullname2
	, COALESCE(ML.LikesCount, 0) + COALESCE(MR.RetweetsCount, 0) AS MutualInteractionCount
FROM Twitter.Users U1
INNER JOIN Twitter.Users U2 ON U1.UserID < U2.UserID
LEFT JOIN MutualLikes ML ON U1.UserID IN (ML.UserID1, ML.UserID2) AND U2.UserID IN (ML.UserID1, ML.UserID2)
LEFT JOIN MutualRetweets MR ON U1.UserID IN (MR.UserID1, MR.UserID2) AND U2.UserID IN (MR.UserID1, MR.UserID2)
WHERE ML.LikesCount IS NOT NULL OR MR.RetweetsCount IS NOT NULL
ORDER BY MutualInteractionCount DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
;



-- Scenario Q34 - Identify Users Most Frequently Engaged in Conversations via Direct Messages
WITH DirectConversation AS (
	SELECT D.SenderID AS UserID1
		, D.ReceiverID AS UserID2
	FROM Twitter.DirectMessages D
	GROUP BY D.SenderID, D.ReceiverID
	)
SELECT U.UserID
	, U.Username
	, U.FullName
	, COUNT(*) AS ConversationCount
FROM Twitter.Users U
INNER JOIN DirectConversation DC ON U.UserID = DC.UserID1 AND U.UserID = DC.UserID2
GROUP BY U.UserID, U.Username, U.FullName
ORDER BY COUNT(*) DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY 
;