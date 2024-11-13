/* 
Guest House exercise from https://sqlzoo.net/wiki/Guest_House

guest house database description

6 tables: booking, room, extra, guest, rate, room_type

--------------------------------------------------------
Table booking
core table of guest house database
each past/future booking made at the hotel has a record
A booking is made by one guest, even though more than one person may be staying we do not record the details of other guests in the same room. 
The amount charged depends on the room type and the number of people staying and the number of nights, and extras (for breakfast or using the minibar)
--------------------------------------------------------
Field	            Type	    Null	Key	    Default     Description
booking_id	        int(11)	    NO	    PRI		            unique booking id
booking_date	    date	    YES		                    date of the first night	rather than date the booking was made
room_no	            int(11)	    YES	    MUL		            room number, e.g. '101'
guest_id	        int(11)	    NO	    MUL		            guest id, link to guest table on id
occupants	        int(11)	    NO		        1	        number of guests
room_type_requested	varchar(6)	YES	    MUL		            room type, e.g., 'single', 'double'
nights	            int(11)	    NO		        1	        number of nights stay
arrival_time	    varchar(5)	YES			                arrival time of guest
--------------------------------------------------------


--------------------------------------------------------
Table room
Rooms are either single, double, twin or family.
--------------------------------------------------------
Field	        Type	    Null	Key	    Description
id	            int(11)	    NO	    PRI		room id. link to booking table on room_id
room_type	    varchar(6)	YES	    MUL		either single, double, twin or family. link to room_type table on room_type
max_occupancy	int(11)	    YES	            max number of guests can stay in a room
--------------------------------------------------------


--------------------------------------------------------
Table rate
--------------------------------------------------------
Rooms are charged per night, the amount charged depends on the "room type requested" value of the booking and the number of people staying
e.g. a double room with one person staying costs £56 while a double room with 2 people staying costs £72 per night

Note that the actual room assigned to the booking might not match the room required (a customer may ask for a single room but we actually assign her a double). 
In this case we charge at the "requirement rate".

Field	        Type	        Null	Key	    Default	 Description
room_type	    varchar(6)	    NO	    PRI		         either single, double, twin or family. link to room table on room_type
occupancy	    int(11)	        NO	    PRI	    0	     number of guests in one room
amount	        decimal(10,2)	YES                      money charged per night
--------------------------------------------------------


--------------------------------------------------------
Table extra
guest may have breakfast or use the minibar, so there are extra charges
each booking can have multiple extras
--------------------------------------------------------
Field	        Type	        Null	Key	    Description
extra_id	    int(11)	        NO	    PRI		unique extra id, e.g., '500101'
booking_id	    int(11)	        YES			    booking id reference to booking table on booking_id
description	    varchar(50)	    YES			    description of the extra, e.g., 'Breakfast x 7'
amount	        decimal(10,2)	YES	            charge of extra, e.g., 63.00
--------------------------------------------------------


--------------------------------------------------------
Table room_type
totally 4 records for room type 'single', 'double', 'twin' or 'family'
--------------------------------------------------------
Field	    Type	        Null	Key	     Description
id	        varchar(6)	    NO	    PRI		
description	varchar(100)	YES			
--------------------------------------------------------


--------------------------------------------------------
Table guest 
each guest made booking has a record
--------------------------------------------------------
Field	    Type	        Null	Key	
id	        int(11)	        NO	    PRI		
first_name	varchar(50)	    YES			
last_name	varchar(50)	    YES			
address	    varchar(50)	    YES			
--------------------------------------------------------

*/

-- 
-- Easy
-- 

-- 1. Guest 1183. Give the booking_date and the number of nights for guest 1183.
SELECT 
    DATE_FORMAT(booking_date, '%Y-%m-%d') AS booking_date,nights
FROM booking 
JOIN guest ON guest_id = guest.id
WHERE guest.id= 1183;

-- 2. When do guests get here? 
-- List the arrival time and the first and last names for all guests due to arrive on 2016-11-05, order the output by time of arrival.
SELECT arrival_time, first_name, last_name 
FROM booking b
JOIN guest g ON b.guest_id = g.id
WHERE DATE_FORMAT(booking_date, '%Y-%m-%d') = '2016-11-05'
ORDER BY 1 ASC;

-- 3. Look up daily rates. 
-- Give the daily rate that should be paid for bookings with ids 5152, 5165, 5154 and 5295. Include booking id, room type, number of occupants and the amount.
SELECT booking_id, room_type_requested, occupants, amount
FROM booking
LEFT JOIN rate ON booking.room_type_requested = rate.room_type AND booking.occupants = rate.occupancy
WHERE booking_id in (5152, 5165, 5154, 5295);

-- 4. Who’s in 101? 
-- Find who is staying in room 101 on 2016-12-03, include first name, last name and address.
SELECT g.first_name, g.last_name, g.address
FROM booking b
JOIN guest g ON b.guest_id = g.id
WHERE b.booking_date = '2016-12-03' AND b.room_no = 101;

-- 5. How many bookings, how many nights? 
-- For guests 1185 and 1270 show the number of bookings made and the total number of nights. Your output should include the guest id and the total number of bookings and the total number of nights.
SELECT b.guest_id, COUNT(b.nights), SUM(b.nights)
  FROM booking b
  WHERE b.guest_id in (1185, 1270)
GROUP BY b.guest_id;

-- 
-- Medium
-- 
-- 6. Ruth Cadbury. Show the total amount payable by guest Ruth Cadbury for her room bookings. You should JOIN to the rate table using room_type_requested and occupants.

SELECT
	SUM(booking.nights * rate.amount)
FROM
	booking
	JOIN rate ON (booking.occupants = rate.occupancy AND booking.room_type_requested = rate.room_type)
	JOIN guest ON (guest.id = booking.guest_id)
WHERE
	guest.first_name = 'Ruth'
	AND guest.last_name = 'Cadbury';

-- 7 Including Extras. Calculate the total bill for booking 5128 including extras.

SELECT
	SUM(booking.nights * rate.amount) + SUM(e.amount) AS Total
FROM
	booking
	JOIN
		rate ON (booking.occupants = rate.occupancy AND booking.room_type_requested = rate.room_type)
	JOIN
		(SELECT
            booking_id,
            SUM(amount) as amount
        FROM
            extra
        group by
            booking_id
		)AS e ON (e.booking_id = booking.booking_id)
WHERE
	booking.booking_id = 5128;

-- 8. Edinburgh Residents. For every guest who has the word “Edinburgh” in their address show the total number of nights booked. Be sure to include 0 for those guests who have never had a booking. Show last name, first name, address and number of nights. Order by last name then first name.

SELECT
	guest.last_name,
	guest.first_name,
	guest.address,
    COALESCE(SUM(booking.nights), 0) AS nights
FROM
	guest
	LEFT JOIN booking ON (guest.id = booking.guest_id)
WHERE
	guest.address LIKE '%Edinburgh%'
GROUP BY
	guest.last_name, guest.first_name, guest.address
ORDER BY
	guest.last_name, guest.first_name;

-- 9 Show the number of people arriving. 
-- For each day of the week beginning 2016-11-25 show the number of people who are arriving that day.

SELECT
	DATE_FORMAT(booking_date, '%Y-%m-%d') AS i,
	COUNT(booking_id) AS arrivals
FROM
	booking
WHERE
	booking_date BETWEEN '2016-11-25' AND '2016-12-01'
GROUP BY
	booking_date;

-- 10 How many guests? 
-- Show the number of guests in the hotel on the night of 2016-11-21. Include all those who checked in that day or before but not those who have check out on that day or before.

SELECT
	SUM(occupants)
FROM
	booking
WHERE
	'2016-11-21' BETWEEN booking_date AND booking_date + INTERVAL (nights-1) DAY;

-- 
-- Hard
-- 

-- 11. Coincidence. 
-- Have two guests with the same surname ever stayed in the hotel on the evening? 
-- Show the last name and both first names. Do not include duplicates.
SELECT DISTINCT
    a.last_name,
    a.first_name,
    b.first_name
FROM
    (SELECT * FROM booking JOIN guest ON booking.guest_id = guest.id)
    AS a
    JOIN
        (SELECT * FROM booking JOIN guest ON booking.guest_id = guest.id)
        AS b
        ON a.last_name = b.last_name AND a.first_name > b.first_name
WHERE 
    b.booking_date BETWEEN a.booking_date AND a.booking_date + INTERVAL (a.nights - 1) DAY 
ORDER BY
    a.last_name;

-- 12 Check out per floor. 
-- The first digit of the room number indicates the floor – e.g. room 201 is on the 2nd floor. For each day of the week beginning 2016-11-14 show how many guests are checking out that day by floor number. Columns should be day (Monday, Tuesday ...), floor 1, floor 2, floor 3.

SELECT 
  DATE_FORMAT(booking_date + INTERVAL nights DAY, '%Y-%m-%d') AS i,
  SUM(CASE WHEN room_no LIKE '1%' THEN 1 ELSE 0 END) AS 1st,
  SUM(CASE WHEN room_no LIKE '2%' THEN 1 ELSE 0 END) AS 2nd,
  SUM(CASE WHEN room_no LIKE '3%' THEN 1 ELSE 0 END) AS 3rd
FROM
	booking
WHERE
	(booking_date + INTERVAL nights DAY) BETWEEN '2016-11-14' AND '2016-11-20'
GROUP BY i;


-- 13. Free rooms
-- List the rooms that are free on the day 25th Nov 2016.
-- solution 1: EXCEPT
SELECT room.id
FROM room
EXCEPT
(   SELECT room_no
    FROM booking
    WHERE '2016-11-25' BETWEEN  booking_date AND booking_date + INTERVAL booking.nights-1 DAY
)

-- Solution 2: NOT IN
SELECT room.id
FROM room
WHERE room.id NOT IN (
    SELECT room_no
    FROM booking
    WHERE '2016-11-25' BETWEEN  booking_date AND booking_date + INTERVAL booking.nights-1 DAY
    )

-- 14. Single room for three nights required. 
-- A customer wants a single room for three consecutive nights. Find the first available date in December 2016.


SELECT r.id AS room_id, 
        MIN(b.booking_date + INTERVAL b.nights DAY) AS first_available_date
FROM booking b
JOIN room r ON b.room_no = r.id
WHERE r.room_type = 'single'
    AND DATE_FORMAT(b.booking_date, '%Y-%m') = '2016-12'
    AND NOT EXISTS (
        SELECT 1
        FROM booking b2
        WHERE b2.room_no = b.room_no
            AND DATEDIFF(b2.booking_date, b.booking_date + INTERVAL b.nights DAY) BETWEEN 0 AND 2
    )  
    -- NOT EXISTS subquery: there must not be another booking for the same room within three days after the current booking ends
GROUP BY r.id
ORDER BY first_available_date ASC 
LIMIT 1;


-- 15. Gross income by week. 
-- Money is collected from guests when they leave. 
-- For each Thursday in November and December 2016, show the total amount of money collected from the previous Friday to that day, inclusive.
-- You may find the table calendar useful for this query.
-- calendar table is a pre-created table having date from 2016-11-03 to 2019-08-23
WITH thursdays AS (
    SELECT i AS thursday, i - INTERVAL 6 DAY AS friday
    FROM calendar
    WHERE i >= '2016-11-01' AND i - INTERVAL 6 DAY <= '2016-12-31' AND DAYOFWEEK(i) = 5
),
extras AS (
    SELECT booking_id, SUM(amount) AS total
    FROM extra
    GROUP BY booking_id
)
SELECT thursday,
       SUM(COALESCE(booking.nights * rate.amount, 0) + COALESCE(extras.total, 0)) AS weekly_income
FROM thursdays
    LEFT JOIN booking ON (booking.booking_date + INTERVAL booking.nights DAY) BETWEEN friday AND thursday
    LEFT JOIN rate ON (booking.occupants = rate.occupancy AND booking.room_type_requested = rate.room_type)
    LEFT JOIN extras ON booking.booking_id = extras.booking_id
GROUP BY thursday;
