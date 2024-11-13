/*

Congestion charges exercise from https://sqlzoo.net/wiki/Congestion_Charging

vehicles enter busy areas of a city during peak hours are charged a fee.
the fee is used for facilitate public transportation and encourage keepers don't enter these areas.
vehicle holding permit can enter charging zone for free, otherwise will be issud fines

Congestion database has 5 tables: camera, keeper, vehicle, image, permit

----------------------------------------------------------------------
camera table:

Field	    Type	    Null	Key	    Description
id	        int(11)	    NO	    PRI		unique identifier for each camera. link to image table on camera
perim	    varchar(3)	YES			    perimeter of the camera (视界), indicating whether it takes images for incoming (IN) or outgoing vehicles (OUT) or NULL (INTERVAL)
----------------------------------------------------------------------

----------------------------------------------------------------------
keeper table:
each keeper can have multiple vehicles

Field	    Type	    Null	Key	    Description
id	        int(11)	    NO	    PRI		unique identifier for each keeper 车主. link to vehicle table on keeper
name	    varchar(20)	YES			    name of the keeper. e.g., 'Strenuous, Sam'
address	    varchar(25)	YES	            address of the keeper
----------------------------------------------------------------------

----------------------------------------------------------------------
vehicle table:
each vehicle is owned by a keeper

Field	    Type	        Null	Key	    Description
id	        varchar(10)	    NO	    PRI		unique identifier for each vehicle. e.g., 'SO 02 DSP'. link to image table on reg, permit table on reg
keeper	    int(11)	        YES	    MUL		keeper id. link to keeper table on id
----------------------------------------------------------------------
----------------------------------------------------------------------
image table:
each image captured by a camera for a vehicle has a record 
Field	      Type	        Null	Key	    Description
camera	      int(11)	    NO	    PRI		camera id, link to camera table on id
whn	          datetime	    NO	    PRI		date and time when the image was taken
reg	          varchar(10)	YES	    MUL		registration number of the vehicle in the image. link to vehicle table on id 
----------------------------------------------------------------------

----------------------------------------------------------------------
permit table:
each vehicle can have multiple permits
Field	    Type	        Null	Key	    Description
reg	        varchar(10)	    NO	    PRI		registration number of the vehicle that has a permit. link to vehicle table on id
sDate	    datetime	    NO	    PRI		start date of the permit
chargeType	varchar(10)	    YES	            type of permit, can be daily, weekly, monthly or annual.
----------------------------------------------------------------------
*/

-- Easy questions 1-5
-- 1. Show the name and address of the keeper of vehicle SO 02 PSP.
SELECT keeper.name, keeper.address
FROM keeper JOIN vehicle ON keeper.id = vehicle.keeper
WHERE vehicle.id = 'SO 02 PSP';

-- 2. Show the number of cameras that take images for incoming vehicles.

SELECT COUNT(*)
FROM camera
WHERE perim = 'IN';

-- 3. List the image details taken by Camera 10 before 26 Feb 2007.

SELECT *
FROM image
WHERE camera = 10 AND whn < '2007-02-26';

-- 4. List the number of images taken by each camera. 
-- Your answer should show how many images have been taken by camera 1, camera 2 etc. 
-- The list must NOT include the images taken by camera 15, 16, 17, 18 and 19.

SELECT camera, COUNT(*) AS images
FROM image
WHERE camera NOT BETWEEN 15 AND 19
GROUP BY camera;

-- 5. A number of vehicles have permits that start on 30th Jan 2007. List the name and address for each keeper in alphabetical order without duplication.

SELECT DISTINCT(keeper.name), keeper.address
FROM keeper 
    JOIN vehicle ON keeper.id = vehicle.keeper
    JOIN permit ON vehicle.id = permit.reg
WHERE permit.sDate = '2007-01-30'
ORDER BY keeper.name, keeper.address;

-- Medium questions 1-5
-- 1. List the owners (name and address) of Vehicles caught by camera 1 or 18 without duplication.

SELECT DISTINCT(keeper.name), keeper.address
FROM keeper JOIN vehicle ON keeper.id = vehicle.keeper
  JOIN image ON vehicle.id = image.reg
WHERE image.camera IN (1, 18);

-- 2. Show keepers (name and address) who have more than 5 vehicles.

SELECT keeper.name, keeper.address, COUNT(*) AS num_vehicles
FROM keeper JOIN vehicle ON keeper.id = vehicle.keeper
GROUP BY keeper.name, keeper.address
HAVING COUNT(*) > 5;

-- 3. For each vehicle show the number of current permits (suppose today is the 1st of Feb 2007). The list should include the vehicle.s registration and the number of permits. Current permits can be determined based on charge types, e.g. for weekly permit you can use the date after 24 Jan 2007 and before 02 Feb 2007.

SELECT temp.reg, COUNT(*) AS current_permits
FROM (
    SELECT *,
            (CASE WHEN permit.chargeType = 'Daily' THEN permit.sDate + INTERVAL 1 DAY
                WHEN permit.chargeType = 'Weekly' THEN permit.sDate + INTERVAL 1 WEEK
                WHEN permit.chargeType = 'Monthly' THEN permit.sDate + INTERVAL 1 MONTH
                WHEN permit.chargeType = 'Annual' THEN permit.sDate + INTERVAL 1 YEAR
            END) AS expired_date
    FROM permit) AS temp
WHERE '2007-02-01' BETWEEN temp.sDate AND temp.expired_date
-- Why group by? Nobody would buy overlapping permits for their cars...
GROUP BY a.reg;

-- 4. Obtain a list of every vehicle passing camera 10 on 25th Feb 2007. 
-- Show the time, the registration and the name of the keeper if available.

SELECT image.whn, image.reg, keeper.name
FROM image 
    JOIN vehicle ON image.reg = vehicle.id
    JOIN keeper ON vehicle.keeper = keeper.id
WHERE image.camera = 10 AND DATE_FORMAT(image.whn, '%Y-%m-%d') = '2007-02-25';

-- 5. List the keepers who have more than 4 vehicles and one of them must have more than 2 permits. 
-- The list should include the names and the number of vehicles.

WITH temp1 AS (
  SELECT k.id, k.name
  FROM vehicle v 
    JOIN permit p ON v.id = p.reg
    JOIN keeper k ON v.keeper = k.id
  GROUP BY v.id, k.id, k.name
  HAVING COUNT(*) > 2
), temp2 AS (
  SELECT k.id, COUNT(*) AS vehicle_count
  FROM keeper k 
    JOIN vehicle v ON v.keeper = k.id
  GROUP BY k.id
  HAVING COUNT(*) > 4
)
SELECT temp1.name, temp2.vehicle_count
FROM temp1 
    JOIN temp2 ON temp1.id = temp2.id;

-- Hard questions 1-5

-- 1. There are four types of permit.
--    The most popular type means that this type has been issued the highest number of times.
--    Find out the most popular type, together with the total number of permits issued.

-- solution1
SELECT chargeType, COUNT(*) AS permit_count
FROM permit
GROUP BY chargeType
ORDER BY COUNT(*) DESC
LIMIT 1;

-- solution2
WITH temp AS (
  SELECT chargeType, COUNT(*) AS permit_count
  FROM vehicle v 
    JOIN permit p ON v.id = p.reg
  GROUP BY chargeType
)
SELECT *
FROM temp
WHERE permit_count = (SELECT MAX(permit_count) FROM temp);

-- solution3
WITH temp AS (SELECT chargeType, COUNT(*) AS count,
   RANK() OVER (ORDER BY COUNT(*) DESC) AS rk
FROM permit
GROUP BY chargeType)
SELECT chargeType, count
FROM temp
WHERE rk=1




-- 2.  For each of the vehicles caught by camera 19, show the registration, the earliest time at camera 19 and the time and camera captured it when it left the zone.

WITH temp AS (
  SELECT reg, MIN(whn) first_capture_19
  FROM image i JOIN vehicle v ON i.reg = v.id
  WHERE camera = 19 
  GROUP BY reg
)

SELECT temp.reg, first_capture_19, whn AS leave_time, camera
FROM temp
LEFT JOIN image i ON temp.reg = i.reg 
LEFT JOIN camera c ON i.camera = c.id
LEFT JOIN vehicle v ON i.reg=v.id
WHERE c.perim = 'OUT' AND first_capture_19 < whn


-- 3.  For all 19 cameras - show the position as IN, OUT or INTERNAL and the busiest hour for that camera.
*/
WITH temp AS (SELECT c.id, c.perim, HOUR(i.whn) AS hr, COUNT(*) AS count, 
                    RANK() OVER (PARTITION BY c.id ORDER BY COUNT(*) DESC) AS rk
               FROM camera c 
                    LEFT JOIN image i ON c.id = i.camera
                GROUP BY c.id, c.perim, hr
              )
SELECT id, COALESCE(perim, 'INTERNAL') AS position, hr AS hour
FROM temp
WHERE rk=1


-- 4.  Anomalous daily permits.
--     Daily permits should not be issued for non-charging days.
--     Find a way to represent charging days.
--     Identify the anomalous daily permits.
--      Charging times: 07:00-18:00 Mon-Fri, 12:00-18:00 Sat-Sun and bank holidays. No charge between Christmas Day and New Year's Day bank holiday (inclusive)
-- https://tfl.gov.uk/modes/driving/congestion-charge/congestion-charge-zone
-- need a table named bank_holidays that contains a list of bank holiday dates
SELECT reg, sDate
FROM permit
WHERE chargeType = 'daily'
AND (
    (WEEKDAY(sDate) BETWEEN 0 AND 4 AND (TIME(sDate) NOT BETWEEN '07:00:00' AND '18:00:00'))
    OR (WEEKDAY(sDate) BETWEEN 5 AND 6 AND (TIME(sDate) NOT BETWEEN '12:00:00' AND '18:00:00'))
    OR (DATE(sDate) BETWEEN '2022-12-25' AND '2023-01-02')
    OR (DATE(sDate) IN (SELECT holiday_date FROM bank_holidays))
)





-- 5.  Issuing fines: Vehicles using the zone during the charge period, on charging days (weekdays)
--   must be issued with fine notices unless they have a permit covering that day.
-- List the name and address of such culprits, give the camera and the date and time of the first offence.

WITH temp AS (
  SELECT i.reg, k.name, k.address, i.camera, i.whn, p.sDate, 
        (CASE
            WHEN chargeType = 'Daily' THEN sDate + INTERVAL 1 DAY
            WHEN chargeType = 'Weekly' THEN sDate + INTERVAL 1 WEEK
            WHEN chargeType = 'Monthly' THEN sDate + INTERVAL 1 MONTH
            WHEN chargeType = 'Annual' THEN sDate + INTERVAL 1 YEAR
        END) AS eDate,
        RANK() OVER (PARTITION BY k.name ORDER BY i.whn) AS rnk

  FROM image i 
    JOIN vehicle v ON i.reg = v.id
    JOIN keeper k ON v.keeper = k.id
    JOIN permit p ON v.id = p.reg
  WHERE (whn NOT BETWEEN sDate AND eDate) AND (whn IN charging_days)
)
SELECT name, address, camera, whn
FROM temp
WHERE rnk = 1;