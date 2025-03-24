USE HHA
GO
	
SELECT
	ap.AuthorizationFrom, ap.AuthorizationTo, pa.Authorizationnumber, pa.FromDate, pa.ToDate, pa.PatientID,  pa.AuthProviderID, pa.PayerID, 
	va.AuthorizationID, SUM(va.UsedUnitsInVisit) as UnitsUsed, ap.TotalAuthorizations, va.AuthorizationPeriodID
FROM dbo.VisitAuthorizations va WITH (NOLOCK)
INNER JOIN [authorization].[periods] ap WITH (NOLOCK) ON va.AuthorizationPeriodID = ap.AuthorizationPeriodID
INNER JOIN dbo.PatientAuthorization pa WITH (NOLOCK) ON va.AuthorizationID = pa.PatientAuthorizationID
GROUP BY ap.AuthorizationFrom, ap.AuthorizationTo, va.AuthorizationPeriodID, va.authorizationid, ap.TotalAuthorizations, pa.FromDate, pa.ToDate, pa.PatientID, pa.AuthProviderID, pa.PayerID, pa.Authorizationnumber
HAVING ap.AuthorizationFrom > DATEADD(DAY, -30, GETDATE()) 
	AND SUM(va.UsedUnitsInVisit) >  ap.TotalAuthorizations
	AND COUNT(va.AuthorizationPeriodID) > 1
ORDER BY ap.AuthorizationFrom DESC
