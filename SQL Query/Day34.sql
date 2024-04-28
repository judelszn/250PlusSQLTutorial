-- Business scenario Q216 - Analysing Scrap Reasons for Production Delays
WITH ProductionDelays AS (
	SELECT SR.Name AS ScrapReason
		, COUNT(DISTINCT WO.WorkOrderID) AS DelayedWorkOrders
	FROM Production.WorkOrder WO
	LEFT JOIN Production.ScrapReason SR
	ON WO.ScrapReasonID = SR.ScrapReasonID
	WHERE WO.EndDate > WO.DueDate
	GROUP BY SR.Name
)
SELECT PD.ScrapReason
	, PD.DelayedWorkOrders
FROM ProductionDelays PD
ORDER BY PD.DelayedWorkOrders DESC
;


-- Business scenario Q217 - Identifying Work Orders with Longest Routing Times