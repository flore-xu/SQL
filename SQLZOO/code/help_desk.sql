/* Help Desk exercise from https://sqlzoo.net/wiki/Help_Desk

help desk database 

-------------------------------------------------------
table Issue
core table in help desk database.
each call has a record in table Issue
-------------------------------------------------------
Field			Type			Null	Key	    Description
Call_ref		int(11)			NO		PRI     unique call id
Call_date		datetime		NO				date of the call, e.g., 'Sat, 12 Aug 2017 08:16:00 GMT'	
Caller_id		int(11)			NO		MUL		link to Caller table on Caller_id
Detail			varchar(255)	YES			    description of issue, e.g., 'How can I guarantee a digital communication in Oracle ?'
Taken_by		varchar(6)		NO		MUL		link to Staff table on Staff_code. staff_code of the staff by whom the call was taken
Assigned_to		varchar(6)		NO		MUL		link to Staff table on Staff_code. staff_code of the staff to whom the call was assigned
Status			varchar(10)		YES			    status of the issue, either 'Closed' or 'Open'.
-------------------------------------------------------


------------------------------------------------------
table Caller
each caller is contact for a company, makes a call to report issue.
-------------------------------------------------------
Field		Type			Null	Key		Default	        Description
Caller_id	int(11)			NO		PRI		auto_increment  unique caller id. link to Issue table on Caller_id, link to Customer table on Contact
Company_ref	int(11)			YES		MUL						company id. link to Customer table on Company_ref
First_name	varchar(50)		YES								first name of caller
Last_name	varchar(50)		YES								last name of caller
-------------------------------------------------------


-------------------------------------------------------
table Customer
each company authorises multiple callers to make a call
-------------------------------------------------------
Field			Type			Null	Key		Description
Company_ref		int(11)			NO		PRI		unique company id
Company_name	varchar(50)		YES				company name, e.g., 'Haunt Services'
Contact_id		int(11)			YES		MUL		contact for company. link to Caller table on Caller_id
Address_1		varchar(50)		YES			
Address_2		varchar(50)		YES			
Town			varchar(50)		YES			
Postcode		varchar(50)		YES			
Telephone		varchar(50)		YES			
-------------------------------------------------------



-------------------------------------------------------
table Level
each staff has a level from 1-7.
a staff can be manager, operator, engineer simultaneously
-------------------------------------------------------
Field			Type		Null	Key	   Description
Level_code		int(11)		NO		PRI	   unique level code 1-7
Manager			char(1)		YES			   'Y' or NULL
Operator		char(1)		YES			   'Y' or NULL
Engineer		char(1)		YES			   'Y' or NULL
-------------------------------------------------------

-------------------------------------------------------
table Shift
each shift arrangement has a record, allocates one manager, one 
operator, 2 engineers
-------------------------------------------------------
Field			Type		Null	Key		Description
Shift_date		date		NO		PRI		
Shift_type		varchar(7)	NO		PRI		Either 'Early' or 'Late'
Manager			varchar(7)	NO		MUL		staff_code
Operator		varchar(7)	NO		MUL		staff_code
Engineer1		varchar(7)	NO		MUL		staff_code
Engineer2		varchar(7)	YES		MUL		staff_code
-------------------------------------------------------

-------------------------------------------------------
table Shift_type
totally 2 records
'Early' shift: 08:00 - 14:00
'Late' shift: 14:00 - 20:00
-------------------------------------------------------
Field		Type		Null	Key		Description
Shift_type	varchar(7)	NO		PRI		'Early' or 'Late'
Start_time	varchar(5)	YES				 
End_time	varchar(5)	YES				
-------------------------------------------------------

-------------------------------------------------------
table Staff
each staff work for help desk has a record
-------------------------------------------------------
Field		Type			Null	Key	
Staff_code	varchar(6)		NO		PRI		e.g., 'LB1'. link to Issue table on taken_by or assigned_to, Shift table on Manager, Operator, Engineer1, Engineer2
First_name	varchar(50)		YES			
Last_name	varchar(50)		YES			
Level_code	int(11)			NO		MUL		link to Level table on Level_code
-------------------------------------------------------


*/

-- 
-- Helpdesk Easy Questions
-- 

-- 1. There are three issues that include the words "index" and "Oracle". 
-- Find the call_date for each of them
SELECT 
    DATE_FORMAT(call_date, '%Y-%m-%d %H:%i:%s') AS call_date, 
    call_ref 
FROM 
    Issue
WHERE 
    detail LIKE '%index%' 
    AND detail LIKE '%Oracle%';

-- 2. Samantha Hall made three calls on 2017-08-14. 
-- Show the date and time for each
SELECT 
    DATE_FORMAT(call_date, '%Y-%m-%d %H:%i:%s') AS call_date, 
    first_name, 
    last_name
FROM 
    Issue
    LEFT JOIN Caller ON Issue.caller_id = Caller.caller_id
WHERE 
    DATE_FORMAT(Issue.call_date, '%Y-%m-%d') = '2017-08-14' 
    AND Caller.first_name='Samantha' 
    AND Caller.last_name= 'Hall';

-- 3. There are 500 calls in the system (roughly). 
-- Write a query that shows the number that have each status.
SELECT 
    status, 
    COUNT(*) AS Volume
FROM 
    Issue
GROUP BY 
    status;


-- 4. Calls are not normally assigned to a manager but it does happen. 
-- How many calls have been assigned to staff who are at Manager Level?
SELECT COUNT(*) AS mlcc
FROM Issue
    LEFT JOIN Staff ON Issue.assigned_to = Staff.staff_code
    LEFT JOIN Level ON Level.level_code = Staff.level_code
WHERE 
    Level.Manager = 'Y';

-- 5. Show the manager for each shift. 
-- Your output should include the shift date and type; also the first and last name of the manager.
SELECT 
     DATE_FORMAT(shift_date, '%Y-%m-%d') AS shift_date, 
     shift_type, 
     Staff.first_name, 
     Staff.last_name
FROM Shift
     LEFT JOIN Staff ON Shift.manager=Staff.staff_code;

-- 
-- Helpdesk Medium Questions
-- 

-- 6. List the Company name and the number of calls for those companies with more than 18 calls.
SELECT
	Customer.Company_name,
	COUNT(*) AS cc
FROM
	Customer
	JOIN Caller ON Customer.Company_ref = Caller.Company_ref
	JOIN Issue ON Caller.Caller_id = Issue.Caller_id
GROUP BY
	Customer.Company_name
HAVING
	COUNT(*) > 18;

-- 7. Find the callers who have never made a call. 
-- Show first name and last name
SELECT
	Caller.first_name,
	Caller.last_name
FROM
	Caller
	LEFT JOIN Issue ON Caller.Caller_id = Issue.Caller_id
WHERE
	Issue.Caller_id IS NULL;

-- 8. For each customer show: Company name, contact name, number of calls where the number of calls is fewer than 5
SELECT
	a.Company_name,
	b.first_name,
	b.last_name,
	a.nc
FROM
	(SELECT
			Customer.Company_name,
			Customer.Contact_id,
			COUNT(*) AS nc
    FROM
        Customer
        JOIN Caller ON (Customer.Company_ref = Caller.Company_ref)
        JOIN Issue ON (Caller.Caller_id = Issue.Caller_id)
    GROUP BY
        Customer.Company_name,
        Customer.Contact_id
    HAVING
        COUNT(*) < 5
	)AS a
	JOIN (SELECT * FROM Caller) AS b ON (a.Contact_id = b.Caller_id);

-- 9. For each shift show the number of staff assigned. 
-- Beware that some roles may be NULL and that the same person might have been assigned to multiple roles (The roles are 'Manager', 'Operator', 'Engineer1', 'Engineer2').
SELECT
	DATE_FORMAT(a.Shift_date, '%Y-%m-%d') AS Shift_date,
	a.Shift_type,
	COUNT(DISTINCT role) AS cw
FROM
	(
		SELECT
			shift_date,
			shift_type,
			Manager AS role
		FROM
			Shift
		UNION ALL
		SELECT
			shift_date,
			shift_type,
			Operator AS role
		FROM
			Shift
		UNION ALL
		SELECT
			shift_date,
			shift_type,
			Engineer1 AS role
		FROM
			Shift
		UNION ALL
		SELECT
			shift_date,
			shift_type,
			Engineer2 AS role
		FROM
			Shift
	) AS a
GROUP BY
	a.Shift_date,
	a.Shift_type;

-- 10. Caller 'Harry' claims that the operator who took his most recent call was abusive and insulting. 
-- Find out who took the call (full name) and when.
SELECT
	Staff.First_name,
	Staff.Last_name,
	DATE_FORMAT(a.call_date, '%Y-%m-%d %H:%i:%s') AS call_date
FROM
	(
		SELECT
			Issue.Caller_id,
			MAX(Call_date) AS Call_date 
		FROM
			Issue 
			JOIN Caller ON Issue.Caller_id = Caller.Caller_id
		WHERE
			Caller.First_name = 'Harry' 
		GROUP BY
			Issue.Caller_id
	)AS a 
	JOIN Issue ON (a.Caller_id = Issue.Caller_id AND a.Call_date = Issue.Call_date) 
	JOIN Staff ON (Issue.Taken_by = Staff.Staff_code);



-- 
-- Helpdesk Hard Questions
-- 

-- 11. Show the manager and number of calls received for each hour of the day on 2017-08-12
SELECT
	Shift.Manager,
	i.date_hour as Hr,
	COUNT(*) as CC
FROM
	(
		SELECT
			DATE_FORMAT(call_date, '%Y-%m-%d %H') date_hour,
			DATE_FORMAT(call_date, '%Y-%m-%d') date,
			DATE_FORMAT(call_date, '%H') hour,
			Taken_by
		FROM
			Issue
		WHERE
			YEAR(call_date) = '2017'
			AND MONTH(call_date) = '08'
			AND DAY(call_date) = '12'
	)AS i
	JOIN Shift ON (i.date = Shift.Shift_date)
WHERE
	Shift.Shift_type = 'early'
	AND i.hour <= 13
	OR Shift.Shift_type = 'late'
	AND i.hour > 13
GROUP BY
	Shift.Manager,
	i.date_hour
ORDER BY
	i.date_hour
;


-- 12. 80/20 rule. It is said that 80% of the calls are generated by 20% of the callers. 
-- Is this true? What percentage of calls are generated by the most active 20% of callers.
WITH ranked_callers AS (
    SELECT caller_id, COUNT(*) AS calls_per_caller,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM Issue
    GROUP BY caller_id
),
top_20_percent AS (
    SELECT SUM(calls_per_caller) AS top_20_calls
    FROM ranked_callers
    WHERE rnk <= (SELECT ROUND(MAX(rnk) * 0.2, 0) FROM ranked_callers)
),
total_calls AS (
    SELECT SUM(calls_per_caller) AS total_calls
    FROM ranked_callers
)
SELECT ROUND((top_20_calls / total_calls) * 100, 4) AS percentage_of_calls
FROM top_20_percent, total_calls;

-- 13. Annoying customers. Customers who call in the last five minutes of a shift are annoying. 
-- Find the most active customer who has never been annoying.
SELECT
	Customer.Company_name,
	COUNT(*) AS abna
FROM
	Customer
	JOIN Caller ON (Customer.Company_ref = Caller.Company_ref)
	JOIN Issue ON (Caller.Caller_id = Issue.Caller_id)
WHERE
	Customer.Company_name NOT IN (
		SELECT
			Customer.Company_name
		FROM
			Customer
			JOIN Caller ON (Customer.Company_ref = Caller.Company_ref)
			JOIN Issue ON (Caller.Caller_id = Issue.Caller_id)
		WHERE
			DATE_FORMAT(call_date, '%H') IN (13, 19)
			AND DATE_FORMAT(call_date, '%i') >= 55
        )
GROUP BY
	Customer.Company_name
ORDER BY
	COUNT(*) DESC 
LIMIT 1;

-- 14. Maximal usage
-- If every caller registered with a customer makes at least one call in one day then that customer has "maximal usage" of the service.
-- List the maximal customers for 2017-08-13.
SELECT a.company_name, b.caller_count, a.registered_callers
FROM
(SELECT Customer.company_name, COUNT(*) AS registered_callers
FROM Customer LEFT JOIN Caller ON Customer.company_ref = Caller.company_ref
GROUP BY Customer.company_name) AS a
LEFT JOIN
(SELECT Customer.company_name, COUNT(DISTINCT(Caller.caller_id)) AS caller_count
FROM Issue LEFT JOIN 
Caller ON Issue.caller_id = Caller.caller_id
  LEFT JOIN Customer ON Caller.company_ref = Customer.company_ref
WHERE DATE_FORMAT(call_date, '%Y-%m-%d') = '2017-08-13'
GROUP BY Customer.company_name
) AS b
ON a.company_name = b.company_name
WHERE a.registered_callers <= b.caller_count


-- 15. Consecutive calls
-- Consecutive calls occur when an operator deals with two callers within 10 minutes. 
-- Find the longest sequence of consecutive calls – give the name of the operator and the first and last call date in the sequence.

SELECT
	a.taken_by,
	DATE_FORMAT(a.first_call, '%Y-%m-%d %H:%i:%s') AS first_call,
	DATE_FORMAT(a.last_call, '%Y-%m-%d %H:%i:%s') AS last_call,
	a.call_count AS calls
FROM
	(
		SELECT
			taken_by,
			call_date AS last_call,
			@row_number1:= CASE WHEN TIMESTAMPDIFF(MINUTE, @call_date, call_date) <= 10 THEN @row_number1 + 1
				                ELSE 1
			               END AS call_count,
			@first_call_date:= CASE WHEN @row_number1 = 1 THEN call_date
				                    ELSE @first_call_date
			                    END AS first_call,
			@call_date:= Issue.call_date AS call_date
		FROM
			Issue,
			(SELECT
					@row_number1 := 0,
					@call_date := 0,
					@first_call_date := 0
			)AS row_number_init
		ORDER BY
			taken_by,
			call_date
	)AS a
ORDER BY
	a.call_count DESC 
LIMIT 1;

-- this solution gives wrong answer and I don't know why
WITH ranked_calls AS (
    SELECT taken_by, call_date,
    ROW_NUMBER() OVER (PARTITION BY taken_by ORDER BY call_date) AS row_num
    FROM Issue
),
consecutive_calls AS (
    SELECT a.taken_by, MIN(a.call_date) AS first_call, MAX(b.call_date) AS last_call,
    COUNT(*) AS calls
    FROM ranked_calls a
    JOIN ranked_calls b
    ON a.taken_by = b.taken_by AND a.row_num = b.row_num - 1
    WHERE TIMESTAMPDIFF(MINUTE, a.call_date, b.call_date) <= 10
    GROUP BY a.taken_by
)
SELECT taken_by, first_call, last_call, calls
FROM consecutive_calls
ORDER BY calls DESC
LIMIT 1;