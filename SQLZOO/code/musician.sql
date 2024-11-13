/* Musicians exercises from https://sqlzoo.net/wiki/Musicians


Musician database description

10 tables: band, composer, composition, concert, has_composed, musician, performance, performer, place, plays_in

totally 9 bands, 22 musicians, 29 performers, 12 composers, 9 places,  21 compositions, 8 concerts, 20 performances

------------------------------------------------------------------------------------------------------
Table band
Field	        Type	        Null	Key	    Description
band_no	        int       	        NO	    PRI		unique band number. link to performance table on gave, plays_in table on band_id
band_name	    varchar(20)	    YES			    band name. e.g., 'The left Overs'
band_home	    int       	        NO			    place of band. link to place table on place_no
band_type	    varchar(10)	    YES			    type of band. either 'classical', 'jazz'
b_date	        date	        YES			    date of establish.
band_contact	int       	        NO			    contact. link to musician table on m_no
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
Table composer
Field	    Type	    Null	Key	    Description
comp_no	    int       	    NO	    PRI		unique composer number. link to has_composed table on cmpr_no
comp_is	    int       	    NO			    musician number. link to musician table on m_no
comp_type	varchar(10)	YES		        type of composer. either 'jazz', 'classical', 'rock'
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
Table composition
Field	    Type	    Null	Key	    Description
c_no	    int       	    NO	    PRI		unique composition number. link to has_composed table on cmpn_no
comp_date	date	    YES			    date when the composer made this composition
c_title	    varchar(40)	NO			    title. e.g., 'Little Piece'
c_in	    int       	    YES	            place where the composer made this composition
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
Table concert
Field	            Type	    Null	Key	    Description
concert_no	        int       	    NO	    PRI		unique concert number. link to performance table on performed_in
concert_venue	    varchar(20)	YES			    venue, e.g., 'Bridgewater Hall'
concert_in	        int       	    NO			    place, link to place table on place_no
con_date	        date	    YES			    date, e.g., '06/01/95'
concert_orgniser	int       	    YES		        orgniser, link to musician table on m_no
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
Table has_composed
each composer can compose multiple compositions
each composition can be composed by multiple composers
Field	    Type	    Null	Key	        Description
cmpr_no	    int       	    NO	    PRI		    unique composer number. link to composer table on comp_no
cmpn_no	    int       	    NO	    PRI		    composition number. link to composition table on c_no
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
Table musician
Field	    Type	    Null	Key	    Description
m_no	    int       	    NO	    PRI		unique musician number. link to band table on band_contact, concert table on concert_orgniser, performance table on conducted_by, performer table on perf_is, composer table on comp_is
m_name	    varchar(20)	YES			    musician name, e.g., 'Fred Bloggs'
born	    date	    YES			    date of birth, e.g., '02/01/48'
died	    date	    YES			    date of died, e.g., '20/09/80', NULL if not died
born_in	    int       	    YES			    place the musician was born in, link to place table on place_no
living_in	int       	    YES	            place the musician was living in, link to place table on place_no
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
Table performance

each concert has multiple performances, multiple bands
each band can give multiple performances
each performance is performed by a band and has one conductor

Field	        Type	    Null	Key	    Description
pfrmnc_no	    int       	    NO	    PRI		unique performance number
gave	        int       	    YES			    band gave this performance, link to band table on band_no
performed	    int       	    YES			    performer performed in this performance, link to performer table on perf_no
conducted_by	int       	    YES			    musician conducted this performance, link to musician table on m_no
performed_in	int       	    YES			    concert in which this performance performed in, link to concert table on concert_no
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
Table performer
each musician can play multiple instruments of different type ('classica', 'jazz', 'not known')

Field	    Type	    Null	Key	    Description
perf_no	    int       	    NO	    PRI		unique performer number. link to performance table on performed, plays_in table on player
perf_is	    int       	    YES			    musician number, link to musician table on m_no
instrument	varchar(10)	NO			    instrument the musician plays, e.g., 'violin'
perf_type	varchar(10)	YES		        either 'classica', 'jazz', 'not known'
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
Table place
Field	        Type	    Null	Key	    Description
place_no	    int       	    NO	    PRI		unique place number, link to concert table on concert_in, musician table on born_in and living_in, band table on band_home, composition table on c_in
place_town	    varchar(20)	YES			    town/city, e.g., 'Manchester'
place_country	varchar(20)	YES	            country, e.g., 'England'
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
Table plays_in
each musician can play in multiple bands
each band can have multiple musicians
Field	    Type	    Null	Key	    Description
player	    int       	    NO	    PRI		performer number. link to performer table on perf_no
band_id	    int       	    NO	    PRI	    band id, link to band table on band_no
------------------------------------------------------------------------------------------------------
*/
-- Easy Questions 1-5

-- 1. Give the organiser's name of the concert in the Assembly Rooms after the first day of Feb, 1997.

SELECT m_name
FROM concert c 
    JOIN musician m ON c.concert_orgniser = m.m_no
WHERE concert_venue = 'Assembly Rooms' AND con_date > '01/02/1997';


-- 2. Find all the performers who played guitar or violin and were born in England.

SELECT m.m_name
FROM performer p
    LEFT JOIN musician m ON p.perf_is = m.m_no
    LEFT JOIN place p2 ON p2.place_no = m.born_in
WHERE p.instrument IN ('violin', 'guitar') AND p2.place_country = 'England';



-- 3. List the names of musicians who have conducted concerts in USA together with the towns and dates of these concerts.

SELECT DISTINCT m_name, place_town, date_format(con_date, '%Y-%m-%d') as date
FROM performance
    JOIN concert  on (performed_in =concert_no)
    JOIN musician on (conducted_by = m_no)
    JOIN place    on (place_no=concert_in)
WHERE place_country = 'USA'


-- 4. How many concerts have featured at least one composition by Andy Jones?
--    List concert date, venue and the composition's title.

SELECT con_date, concert_venue, c_title
FROM musician m 
    JOIN composer c ON m.m_no = c.comp_is
    JOIN has_composed hc ON c.comp_no = hc.cmpr_no
    JOIN composition cm ON hc.cmpn_no = cm.c_no
    JOIN performance p ON cm.c_no = p.performed
    JOIN concert cn ON p.performed_in = cn.concert_no
WHERE m_name = 'Andy Jones';



-- 5. list the different instruments played by the musicians and avg number of musicians who play the instrument.

SELECT instrument, 
    COUNT(m_no)/(SELECT COUNT(*) FROM musician) as average
FROM musician
    JOIN performer on m_no=perf_is
GROUP BY instrument;


--  Medium Questions 6-10

-- 6. List the names, dates of birth and the instrument played of living musicians who play a instrument which Theo also plays.

SELECT DISTINCT m_name, DATE_FORMAT(born, '%d/%m/%y') AS born, instrument
FROM musician m 
    JOIN performer p ON m.m_no = p.perf_is
    JOIN place pl ON pl.place_no = m.born_in
WHERE instrument IN (
        SELECT instrument
        FROM musician m JOIN performer p ON m.m_no = p.perf_is
        WHERE m_name LIKE '%Theo%')
    AND died IS NULL 
    AND m_name NOT LIKE '%Theo%';



-- 7. List the name and the number of players for the band whose number of players is greater than the average number of players in each band.

WITH temp AS (
  SELECT band_name, COUNT(*) cnt
  FROM band b JOIN plays_in p ON b.band_no = p.band_id
  GROUP BY band_name
)
SELECT band_name, cnt
FROM temp
WHERE cnt > (SELECT AVG(cnt) FROM temp);




-- 8. List the names of musicians who both conduct and compose and live in Britain.
-- use inner join
SELECT DISTINCT m_name
FROM musician m 
    JOIN performance p ON m.m_no = p.conducted_by
    JOIN composer c ON m.m_no = c.comp_is
    JOIN place pl ON m.living_in = pl.place_no
WHERE place_country IN ('England', 'Scotland');



-- 9. Show the least commonly played instrument and the number of musicians who play it.
*/
WITH temp AS (
  SELECT instrument, COUNT(*) cnt
  FROM performer
  GROUP BY instrument
  ORDER BY cnt
)
SELECT *
FROM temp
WHERE cnt = (SELECT MIN(cnt) FROM temp);



-- 10. List the bands that have played music composed by Sue Little;
--    Give the titles of the composition in each case.

SELECT band_name, c_title
FROM musician m 
    JOIN composer c ON m.m_no = c.comp_is
    JOIN has_composed hc ON c.comp_no = hc.cmpr_no
    JOIN composition cm ON hc.cmpn_no = cm.c_no
    JOIN performance p ON cm.c_no = p.performed
    JOIN band b ON p.gave = b.band_no
WHERE m_name = 'Sue Little';



-- Musicians Hard Questions 11-15

-- 11. List the name and town of birth of any performer born in the same city as James First.


SELECT DISTINCT m_name, place_town
FROM musician m 
    JOIN place pl ON m.born_in = pl.place_no
    JOIN performer p ON m.m_no = p.perf_is
WHERE place_town = (
        SELECT place_town
        FROM musician m JOIN place pl ON m.born_in = pl.place_no
        WHERE m_name = 'James First'
        ) 
    AND m_name != 'James First';



-- 12. Create a list showing for EVERY musician born in Britain the number of compositions and the number of instruments played.

WITH temp1 AS (
    SELECT m_name
    FROM musician m JOIN place pl ON m.born_in = pl.place_no
    WHERE place_country IN ('England', 'Scotland')
), 
 temp2 AS (
    SELECT m_name, COUNT(*) comp_cnt
    FROM musician m JOIN composer c ON m.m_no = c.comp_is
    JOIN has_composed hc ON c.comp_no = hc.cmpr_no
    JOIN composition cm ON hc.cmpn_no = cm.c_no
    GROUP BY m_name
), 
 temp3 AS (
    SELECT m_name, COUNT(*) instr_cnt
    FROM musician m JOIN performer p ON m.m_no = p.perf_is
    GROUP BY m_name
)
SELECT temp1.m_name AS musician, 
    COALESCE(comp_cnt, 0) AS compositions, 
    COALESCE(instr_cnt, 0) AS instruments
FROM temp1 
    LEFT JOIN temp2 ON temp1.m_name = temp2.m_name
    LEFT JOIN temp3 ON temp1.m_name = temp3.m_name;



-- 13.  Give the band name, conductor and contact of the bands performing at the most recent concert in the Royal Albert Hall.

SELECT band_name, 
    m.m_name conductor, 
    m1.m_name contact
FROM concert c 
    JOIN performance p ON c.concert_no = p.performed_in
    JOIN band b ON b.band_no = p.gave
    JOIN musician m1 ON b.band_contact = m1.m_no
    JOIN musician m ON p.conducted_by = m.m_no
WHERE concert_venue = 'Royal Albert Hall'
ORDER BY c.con_date DESC
LIMIT 1;



-- 14.  Give a list of musicians associated with city Glasgow.
    -- Include the name of the musician and the nature of the association -
    --   one or more of 'LIVES_IN', 'BORN_IN', 'PERFORMED_IN' AND 'IN_BAND_IN'.

WITH musicians_in_glasgow AS (
    SELECT m_name AS name,
        CASE WHEN born_in IN (SELECT place_no FROM place WHERE place_town = 'Glasgow') THEN 'Yes' END AS Born_In,
        CASE WHEN living_in IN (SELECT place_no FROM place WHERE place_town = 'Glasgow') THEN 'Yes' END AS Lives_In,
        CASE WHEN m_no IN (
            SELECT player FROM plays_in
            JOIN performance ON band_id = gave
            JOIN concert ON performed_in = concert_no
            JOIN place ON concert_in = place_no AND place_town = 'Glasgow'
        ) THEN 'Yes' END AS Performed_In,
        CASE WHEN m_no IN (
            SELECT player FROM plays_in
            JOIN band ON band_id = band_no
            JOIN place ON band_home = place_no AND place_town = 'Glasgow'
        ) THEN 'Yes' END AS In_Band_In
    FROM musician
)
SELECT * FROM musicians_in_glasgow
WHERE COALESCE(Born_In, Lives_In, Performed_In, In_Band_In) IS NOT NULL;




