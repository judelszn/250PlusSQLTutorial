USE TwitterDB;

-- Scenario Q5 - Determine User Growth Over Time
SELECT FORMAT(CONVERT(DATE, U.JoinDate), 'yyyy-MM') AS MonthJoined
	, COUNT(U.UserID) AS UserCountPerMonth
FROM Twitter.Users U
GROUP BY FORMAT(CONVERT(DATE, U.JoinDate), 'yyyy-MM')
ORDER BY MonthJoined ASC
;



-- Scenario Q6 - Analyse Notification Engagement
SELECT N.NotificationType
	, COUNT(N.NotificationID) AS NotificationsCount
	, SUM(CASE WHEN N.IsRead = 1 THEN 1 ELSE 0 END) AS TotalReadNotification
	, ROUND(CAST(SUM(CASE WHEN N.IsRead = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(N.NotificationID) * 100, 2)
		AS ReadRate
FROM Twitter.Notifications N
GROUP BY N.NotificationType
ORDER BY COUNT(N.NotificationID) ASC
;