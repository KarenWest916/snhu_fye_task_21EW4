


/*
Campaign-Admission Opportunity Query for Test Campaigns

*/


SELECT

	Opp.test_id AS test_id,
	Opp.Name AS test_group,
	CASE WHEN Opp.Name like '%control%' THEN 'Control'
	ELSE 'Test' END AS testing_group,
       Opp.ContactId AS contact_id,
       Opp.Id AS opportunity_id,
	   t.Name AS term_name,
       o.StageName AS stage_name,
       o.Inquired_Date_Time__c AS inquired_date_time__c,
       o.Applied_Date_Time__c AS application_date_time__c,
       o.App_in_Progress_Date_Time__c AS application_in_progress_date_time__c,
       o.Accepted_Date_Time__c AS accepted_date_time__c,
       o.Registered_Date_Time__c AS registered_date_time__c,
       1 AS inquiry_count,
	   	   CASE WHEN CE.Last_Course_LMS_Login_Date__c IS NULL THEN 0 ELSE 1 end AS 'FYE-101 Login',
       CASE
           WHEN o.Applied_Date_Time__c IS NOT NULL THEN
               1
           ELSE
               0
       END AS application_count,
       CASE
           WHEN o.App_in_Progress_Date_Time__c IS NOT NULL THEN
               1
           ELSE
               0
       END AS application_in_progress_count,

       CASE
           WHEN o.Accepted_Date_Time__c IS NOT NULL THEN
               1
           ELSE
               0
       END AS accept_count,

       CASE
           WHEN o.Registered_Date_Time__c IS NOT NULL THEN
               1
           ELSE
               0
       END AS registration_count,
       CASE
           WHEN o.Registered_Date_Time__c IS NOT NULL
                AND o.StageName IN ( 'Registered','Started','Closed Won' ) THEN
               1
           ELSE
               0
       END AS start_count

FROM UnifyStaging.dbo.Opportunity o
    INNER JOIN
    (
        --Inner SELECT to grab all opportunities related to prospects in the campaigns we want, then grab most recent for analysis.
        SELECT cm.ContactId,
			   c.ID AS test_id,
               c.Name,
               o2.Id,
               o2.CreatedDate,
               ROW_NUMBER() OVER (PARTITION BY cm.ContactId ORDER BY o2.CreatedDate DESC) AS RN
        --COUNT(1)
        --CM.*, C.*
        FROM UnifyStaging.dbo.CampaignMember cm
            INNER JOIN UnifyStaging.dbo.Campaign c
                ON c.Id = cm.CampaignId
            INNER JOIN UnifyStaging.dbo.Opportunity o2
                ON o2.Contact__c = cm.ContactId
            INNER JOIN UnifyStaging.dbo.RecordType RT
                ON RT.Id = o2.RecordTypeId
        WHERE RT.Name = 'Admission Opportunity'
              --Which campaign(s) are we searching for?
              AND c.Name LIKE '%fye%'
    ) AS Opp
        ON Opp.Id = o.Id
           AND Opp.RN = 1
    left JOIN UnifyStaging.dbo.hed__Term__c t
        ON t.Id = o.Term__c
			LEFT JOIN [UnifyStaging].[dbo].hed__Course_Enrollment__c CE
	ON Opp.ContactId = CE.hed__Contact__c	
	WHERE t.name = '21EW4'
	and ce.Course_ID__c = 'FYE-101'
--GROUP BY Opp.Name
ORDER BY inquired_date_time__c