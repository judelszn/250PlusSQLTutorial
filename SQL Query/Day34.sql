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


-- Business scenario Q217 - Identifying Work Orders with Longest Routing TimesWITH WorkOrderRoutingTimes AS (	SELECT WO.WorkOrderID		, MAX(DATEDIFF(SECOND,WR.ActualStartDate,WR.ActualEndDate)) AS MaximumRoutingTimeInSeconds	FROM Production.WorkOrder WO	INNER JOIN Production.WorkOrderRouting WR	ON WO.WorkOrderID = WR.WorkOrderID	GROUP BY WO.WorkOrderID)SELECT TOP 5 WO.WorkOrderID	, WT.MaximumRoutingTimeInSecondsFROM WorkOrderRoutingTimes WTINNER JOIN Production.WorkOrder WOON WT.WorkOrderID = WO.WorkOrderIDORDER BY WT.MaximumRoutingTimeInSeconds DESC;-- Business scenario Q218 - Analysing Work Order Completion RatesWITH WorkOrderCompleteion AS (	SELECT WR.WorkOrderID		, WR.OperationSequence		, CASE			WHEN WR.ActualEndDate <= WO.DueDate THEN 'On Time'			ELSE 'Delayed'		  END AS CompletionStatus		FROM Production.WorkOrder WO	INNER JOIN Production.WorkOrderRouting WR	ON WO.WorkOrderID = WR.WorkOrderID)SELECT WC.OperationSequence	, SUM(CASE WHEN WC.CompletionStatus = 'On Time' THEN 1 ELSE 0 END) AS CompletedOnTime	, SUM(CASE WHEN WC.CompletionStatus = 'Delayed' THEN 1 ELSE 0 END) AS CompletedDelayed	, COUNT(*) AS TotalEorkOrderFROM WorkOrderCompleteion WCGROUP BY WC.OperationSequenceORDER BY WC.OperationSequence;-- Business scenario Q219 - Optimising Work Order RoutingWITH WorkOrderLocation AS (	SELECT WR.WorkOrderID		, WR.OperationSequence		, WR.LocationID		, PL.Name AS LocationName	FROM Production.WorkOrderRouting WR	INNER JOIN Production.Location PL	ON WR.LocationID = PL.LocationID)SELECT WO.WorkOrderID	, WO.DueDate	, WL.OperationSequence	, WL.LocationNameFROM Production.WorkOrder WOINNER JOIN WorkOrderLocation WLON WO.WorkOrderID = WL.WorkOrderIDORDER BY WO.WorkOrderID, WL.OperationSequence;-- Business scenario Q220 - Monitoring Sales Performance Against QuotasSELECT SP.BusinessEntityID AS SalesPersonID	, QH.QuotaDate	, QH.SalesQuota	, SUM(OH.TotalDue) AS ActualSalesFROM Sales.SalesPerson SPINNER JOIN Sales.SalesPersonQuotaHistory QHON SP.BusinessEntityID = QH.BusinessEntityIDLEFT JOIN Sales.SalesOrderHeader OHON SP.BusinessEntityID = OH.SalesPersonID AND QH.QuotaDate = OH.OrderDateGROUP BY SP.BusinessEntityID, QH.QuotaDate, QH.SalesQuotaORDER BY SP.BusinessEntityID, QH.QuotaDate;