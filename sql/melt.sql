SELECT 
nsh.Student_SK,
       nsh.StudentColleagueID,
	   nsh.InitialRegistrationDate,
	   nsh.EnrolledDay1,
       nsh.EnrolledDay15,
	   nsh.Term
	   FROM aarda.[dbo].[NewStartsHistoricalReport] AS nsh

	   --WHERE 
	   --nsh.StudentColleagueID = '1980318'

    --  nsh.term LIKE '%21EW4%'
