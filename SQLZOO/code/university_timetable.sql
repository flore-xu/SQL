/* University timetable exercises on Neeps database from https://sqlzoo.net/wiki/Neeps_easy_questions

Neeps database description

9 tables: attends, event, modle, occurs, room, staff, student, teaches, week
includes details of all teaching events in the School of Computing at Napier University in Semester 1 of the 2000/2001 academic year.

----------------------------------------------------------
Table event
----------------------------------------------------------
core table in database. 
each event has a record specifying module, time and room

Field	    Type	        Null	Key	    Description
id	        varchar(20)	    NO	    PRI		unique event id, e.g., 'co12004.L01'. link to table attends on event, table teaches on event, table occurs on event
modle	    varchar(20)	    YES	    MUL		FK. module id, e.g., 'co12004'. link to table modle
kind	    char(1)	        YES			    either 'L' or 'T'
dow	        varchar(15)	    YES			    day of week, from 'Monday' to 'Friday'
tod	        char(5)	        YES			    time of day, e.g., '11:00'
duration	int(11)	        YES			    event duration in hours
room	    varchar(20)	    YES	    MUL     FK. room id. link to room table on id. e.g., 'cr.SMH'
----------------------------------------------------------

----------------------------------------------------------
Table modle
----------------------------------------------------------
the module is misspelled as 'modle' because MODULE is a reserved word in database
Field	Type	        Null	Key	    Description
id	    varchar(20)	    NO	    PRI		unique module id. link to event table on modle
name	varchar(50)	    YES	            module name, e.g., 'Computer Systems'
----------------------------------------------------------

----------------------------------------------------------
Table room
----------------------------------------------------------
each classroom has a record
 
Field	    Type	        Null	Key	    Description
id	        varchar(20)	    NO	    PRI		unique classroom id, e.g., 'co.117'
name	    varchar(50)	    YES			    class room name, e.g., 'St Margaret Hall'
capacity	int(11)	        YES			    number of people can sit
parent	    varchar(20)	    YES	    MUL		parent relation is used to maintain groupings. e.g., 'co.117+118' represents a pair of rooms 'co.117' and 'co.118'- sometimes these rooms are used for a single event.
----------------------------------------------------------

----------------------------------------------------------
Table attends
----------------------------------------------------------
records which student group attends which event
links event to student, realises the many to many relation:
- each student group can attend many events
- each event can be attended by many student groups

Field	    Type	        Null	Key	
student	    varchar(20)	    NO	    PRI		link to table student on id
event	    varchar(20)	    NO	    PRI		link to table event on id
----------------------------------------------------------

----------------------------------------------------------
Table student
----------------------------------------------------------
each student group follows the same timetable. 

Field	    Type	        Null	Key	    Description
id	        varchar(20)	    NO	    PRI		unique student group id, e.g, 'co1.CO.a'
name	    varchar(50)	    YES			    group name, e.g., 'Computing 1st Year a'
sze	        int(11)	        YES			    group size, e.g., 20
parent	    varchar(20)	    YES	    MUL		maintain a hierachy of groups. e.g., A student in group co1.CO.a is also in group co1.CO
----------------------------------------------------------

----------------------------------------------------------
Table staff
----------------------------------------------------------
each teacher has a record
----------------------------------------------------------
Field	Type	        Null	Key	    Description
id	    varchar(20)	    NO	    PRI		unique staff id. link to table teaches on staff. e.g., 'co.AMn'
name	varchar(50)	    YES			    staff name, e.g., 'Cumming, Andrew'
----------------------------------------------------------

----------------------------------------------------------
Table teaches
----------------------------------------------------------
which staffs teach which events?
many to many relation:
- each staff can teach many events
- each event can be taught by many staffs

Field	Type	        Null	Key	    Description
staff	varchar(20)	    NO	    PRI		staff id. link to table staff on id
event	varchar(20)	    NO	    PRI	    event id. link to table event on id
----------------------------------------------------------


----------------------------------------------------------
Table occurs
----------------------------------------------------------
each event occurs on which week 

Field	Type	    Null	Key	    Description
event	varchar(20)	NO	    PRI		event id. link to table event on id
week	varchar(20)	NO	    PRI		week id. link to table week on id. 01-13

----------------------------------------------------------

----------------------------------------------------------
Table week
----------------------------------------------------------
each week starts at which day

Field	    Type	Null	Key	    Description
id	        char(2)	NO	    PRI		unique week id. link to table occurs on week. 01-13
wkstart	    date	YES			    the day week starts, e.g., week '01' starts at '02/10/00'
----------------------------------------------------------

*/
-- Easy questions: 1 - 5
-- 1. Give the room id in which the event co42010.L01 takes place.

SELECT room
FROM event
WHERE id = 'co42010.L01';


-- 2. For each event in module co72010 show the day, the time and the place.

SELECT dow, tod, room
FROM event
WHERE modle = 'co72010';



-- 3. List the names of the staff who teach on module co72010.

SELECT DISTINCT name
FROM staff s JOIN teaches t ON s.id = t.staff
    JOIN event e ON t.event = e.id
WHERE modle = 'co72010';



-- 4. Give a list of the staff and module number associated with events using room cr.132 on Wednesday,
--    include the time each event starts.

select staff.name, event.modle, event.tod
FROM event
LEFT JOIN teaches ON event.id=teaches.event
LEFT JOIN staff ON staff.id=teaches.staff
WHERE event.room = 'cr.132' AND event.dow='Wednesday';



-- 5. Give a list of the student groups which take modules with the word 'Database' in the name.

select DISTINCT student.name 'group', modle.name 'module'
FROM student
    LEFT JOIN attends ON student.id=attends.student
    LEFT JOIN event ON event.id=attends.event
    LEFT JOIN modle ON modle.id=event.modle
WHERE modle.name LIKE '%Database%';



-- Medium questions: 6 - 10
-- 6. Show the 'size' of each of the co72010 events.
--    Size is the total number of students attending each event.

SELECT e.id, SUM(sze) size
FROM student s 
    JOIN attends a ON s.id = a.student
    JOIN event e ON a.event = e.id
WHERE modle = 'co72010'
GROUP BY e.id;



-- 7. For each post-graduate module, show the size of the teaching team.
--    post graduate modules start with the code co7

SELECT modle, COUNT(DISTINCT staff) staff_count
FROM teaches t 
    JOIN event e ON t.event = e.id
WHERE modle LIKE 'co7%'
GROUP BY modle;



-- 8. Give the full name of those modules which include events taught for fewer than 10 weeks.


SELECT DISTINCT m.name
FROM event e 
    JOIN occurs o ON e.id = o.event
    JOIN modle m ON e.modle = m.id
GROUP BY m.name, e.id
HAVING COUNT(e.id) < 10;



-- 9. Identify those events which start at the same time as one of the co72010 lectures.


SELECT id
FROM event
WHERE CONCAT(dow, tod) IN (
  SELECT DISTINCT CONCAT(dow, tod) start_time
  FROM event
  WHERE modle = 'co72010'
);



-- 10. How many members of staff have contact time which is greater than the average?

WITH temp1 AS (
  SELECT staff, SUM(duration) staff_hrs
  FROM teaches t JOIN event e ON t.event = e.id
  GROUP BY staff
)
SELECT COUNT(*) staff_count
FROM temp1
WHERE staff_hrs > (SELECT AVG(staff_hrs) FROM temp1);


-- Hard questions: 11 - 15

-- 11. co.CHt is to be given all the teaching that co.ACg currently does.
--    Identify those events which will clash.

WITH acg AS (
  SELECT id, dow, tod, duration, week, tod start_time, tod + duration end_time
  FROM teaches t JOIN event e ON t.event = e.id
  JOIN occurs o ON e.id = o.event
  WHERE staff = 'co.ACg'
), cht AS (
  SELECT id, dow, tod, duration, week, tod start_time, tod + duration end_time
  FROM teaches t JOIN event e ON t.event = e.id
  JOIN occurs o ON e.id = o.event
  WHERE staff = 'co.CHt'
)
SELECT DISTINCT cht.id cht_id, acg.id acg_id
FROM cht CROSS JOIN acg
WHERE (cht.week = acg.week AND cht.dow = acg.dow) AND
      ((cht.start_time >= acg.start_time AND cht.start_time < acg.end_time) OR
       (acg.start_time >= cht.start_time AND acg.start_time < cht.end_time));



-- 12. Produce a table showing the utilisation rate and the occupancy level for all rooms with a capacity more than 60.



SELECT r.id, r.capacity, o.event, o.week, e.dow, tod, 
    SUM(s.sze) AS occupancy,
    CONCAT(ROUND(SUM(s.sze) / capacity * 100, 0), '%') AS utlization_rate
FROM room r JOIN event e ON r.id = e.room
JOIN attends a ON e.id = a.event
JOIN student s ON a.student = s.id
JOIN occurs o ON e.id = o.event
WHERE capacity > 60
GROUP BY r.id, r.capacity, o.week, e.dow, o.event, tod
ORDER BY o.week, e.dow, tod, o.event



--  Resit questions: 1 - 5

-- 1.  Give the day and the time of the event co72002.L01.

SELECT dow, tod
FROM event
WHERE id = 'co72002.L01';


-- 2.  For each event in module co72003 show the day, the time and the place.
*/
SELECT id, dow, tod, room
FROM event
WHERE modle = 'co72003';



-- 3.  List the id of the events taught by 'Chisholm, Ken'.

SELECT DISTINCT e.id
FROM staff s 
    JOIN teaches t ON s.id = t.staff
    JOIN event e ON t.event = e.id
WHERE name = 'Chisholm, Ken';


-- 4.  List the staff who teach in cr.SMH.

SELECT DISTINCT s.name
FROM staff s 
    JOIN teaches t ON s.id = t.staff
    JOIN event e ON t.event = e.id
WHERE room = 'cr.SMH';




-- 5.  Show the total number of hours (over the whole semester) of classes for student group com.IS.a

SELECT SUM(duration) total_hrs
FROM student s 
    JOIN attends a ON s.id = a.student
    JOIN event e ON a.event = e.id
    JOIN occurs o ON e.id = o.event
WHERE s.id = 'com.IS.a';