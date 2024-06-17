USE TwitterDB;

-- Scenario Q25 - Identify Inactive Followers
SELECT U.UserID
	, U.Username
	, U.FullName
FROM Twitter.Users U
INNER JOIN Twitter.Followers F ON U.UserID = F.FollowerUserID
WHERE NOT EXISTS (SELECT T.UserID
					FROM Twitter.Tweets T
					WHERE T.UserID = U.UserID
					)
;



-- Scenario Q26 - Identify Users Who Only Like Tweets from a Single User
SELECT Liker.UserID AS LikerUserID
	, Liker.Username AS LikerUsername
	, Liker.FullName AS LikerFullName
	, Likee.UserID AS LikeeUserID
	, Likee.Username AS LikeeUsername
	, Likee.FullName AS LikeeFullName
	, COUNT(*) AS TotalLikes
FROM Twitter.Likes L
INNER JOIN Twitter.Users Liker ON L.UserID = Liker.UserID
INNER JOIN Twitter.Tweets T ON L.TweetID = T.TweetID
INNER JOIN Twitter.Users Likee ON T.UserID = Likee.UserID
GROUP BY Liker.UserID, Liker.Username, Liker.FullName,
	Likee.UserID, Likee.Username, Likee.FullName
HAVING COUNT(DISTINCT Likee.UserID) = 1
;