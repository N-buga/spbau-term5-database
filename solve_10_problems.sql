--1. 
CREATE INDEX on WeeklyCost(week_number);
CREATE INDEX on Accomodations(max_residents);
CREATE INDEX on Countries(name);

WITH CountryWeekResidentAcc AS (
    SELECT A.*
    FROM Accomodations A 
    JOIN WeeklyCost WC ON A.id = WC.accomodation_id
    JOIN Countries C ON A.country_id = C.id
    WHERE WC.week_number = 1 AND A.max_residents >=6 AND C.name = 'Spain'
)

SELECT * FROM CountryWeekResidentAcc
EXCEPT
SELECT CWRA.*
FROM CountryWeekResidentAcc CWRA 
JOIN AccFacilities AF ON CWRA.id = AF.accomodation_id
JOIN Facilities F ON F.id = AF.facility_id
WHERE F.name = 'Wi-Fi';

--2.
WITH Hosts AS (
    SELECT DISTINCT acc.user_id as host_id FROM Accomodations as acc
), Renters AS (
    SELECT DISTINCT app.user_id as renter_id FROM Application as app
    WHERE app.is_accepted = TRUE;
)

SELECT p.name, p.second_name from People as p
JOIN Hosts as h ON h.host_id = p.id
JOIN Renters as r ON r.renter_id = p.id;

--3.
WITH BookingStat AS (
    SELECT COUNT(app.user_id) as bookings_amount, app.accomodation_id as acc_id
    FROM Application as app
    WHERE app.is_accepted = TRUE
    GROUP BY acc_id
), PopularAcc AS (
    SELECT bs.acc_id FROM BookingStat as bs
    WHERE bs.bookings_amount >= 10
)

SELECT p.name, p.second_name FROM People as p
EXCEPT
SELECT p.name, p.second_name FROM People as p
JOIN Accomodations as acc ON p.id = acc.user_id
WHERE acc.id IN (SELECT acc_id FROM PopularAcc);

--4.
SELECT P.e_mail, MIN(A.sum), MAX(A.sum)
FROM People as P
JOIN Application A ON P.id = A.user_id
WHERE A.is_accepted = TRUE
GROUP BY P.id;

--5.
SELECT A.id, AVG(C.mark)
FROM Accomodations as A
JOIN ReviewsAccomodation as R ON A.id = R.accomodation_id
JOIN AccCharacteristics as C ON R.id = C.review_id
GROUP BY A.id;

--6.
SELECT C.name, COUNT(*)
FROM Countries as C
JOIN Accomodations as A ON C.id = A.country_id
GROUP BY C.id;

--7. 

SELECT id_country, name, week_number, AVG(median_cost) as median_cost FROM
	(SELECT C.id as id_country, C.name, WC.week_number,  COALESCE(C.commission, 0) +  7*COALESCE(WC.price, 0) + COALESCE(A.clening_cost, 0) as 		median_cost, COUNT(*) OVER w as cnt, ROW_NUMBER() OVER w as rowN
	FROM Accomodations A
	JOIN Countries C ON A.country_id = C.id
	JOIN WeeklyCost WC ON WC.accomodation_id = A.id
	WINDOW w AS (PARTITION BY C.id, WC.week_number)) Q
WHERE cnt + 1 BETWEEN 2*rowN - 1 AND 2*rowN + 1
GROUP BY week_number, id_country, name
ORDER BY id_country, week_number;

--8. 

WITH Median_country_week 
AS
(SELECT id_country, name, week_number, AVG(median_cost) as median_cost FROM
	(SELECT C.id as id_country, C.name, WC.week_number,  COALESCE(C.commission, 0) +  7*COALESCE(WC.price, 0) + COALESCE(A.clening_cost, 0) as 		median_cost, COUNT(*) OVER w as cnt, ROW_NUMBER() OVER w as rowN
	FROM Accomodations A
	JOIN Countries C ON A.country_id = C.id
	JOIN WeeklyCost WC ON WC.accomodation_id = A.id
	WINDOW w AS (PARTITION BY C.id, WC.week_number)) Q
WHERE cnt + 1 BETWEEN 2*rowN - 1 AND 2*rowN + 1
GROUP BY week_number, id_country, name
ORDER BY id_country, week_number)

SELECT id_country, week_number 
FROM
(SELECT id_country, week_number, median_cost, 
MAX(median_cost) OVER(PARTITION BY id_country) as max_m_cost
FROM Median_country_week) AS With_max
WHERE 2*median_cost < max_m_cost;

--9.
WITH TotalCommission AS (
    SELECT DISTINCT SUM(c.commission), c.name as country FROM Accomodations as acc
    JOIN Application as app ON acc.id = app.accomodation_id
    JOIN Countries as c ON c.id = acc.country_id
    WHERE app.is_accepted = TRUE
    GROUP BY country
), TotalSum AS (
    SELECT commission, SUM(commission) over() as summary, country FROM TotalCommission
)

SELECT TS.country as country_name, 
   TS.commission as summary_commission, 
   ROUND (100 * TS.commission / TS.summary) as percentage FROM TotalSum TS;

--10.
CREATE OR REPLACE VIEW TotalCommission AS
    SELECT DISTINCT SUM(c.commission), c.name as country FROM Accomodations as acc
    JOIN Application as app ON acc.id = app.accomodation_id
    JOIN Countries as c ON c.id = acc.country_id
    WHERE app.is_accepted = TRUE
    GROUP BY country;

CREATE OR REPLACE VIEW FirstQuarterCommission AS
    SELECT DISTINCT SUM(c.commission), c.name as country FROM Accomodations as acc
    JOIN Application as app ON acc.id = app.accomodation_id
    JOIN Countries as c ON c.id = acc.country_id
    WHERE app.is_accepted = TRUE
    AND (EXTRACT (QUARTER FROM DATE (app.start_date))) = 1
    GROUP BY country;

CREATE OR REPLACE VIEW SecondQuarterCommission AS
    SELECT DISTINCT SUM(c.commission), c.name as country FROM Accomodations as acc
    JOIN Application as app ON acc.id = app.accomodation_id
    JOIN Countries as c ON c.id = acc.country_id
    WHERE app.is_accepted = TRUE
    AND (EXTRACT (QUARTER FROM DATE (app.start_date))) = 2
    GROUP BY country;

CREATE OR REPLACE VIEW ThirdQuarterCommission AS
    SELECT DISTINCT SUM(c.commission), c.name as country FROM Accomodations as acc
    JOIN Application as app ON acc.id = app.accomodation_id
    JOIN Countries as c ON c.id = acc.country_id
    WHERE app.is_accepted = TRUE
    AND ( EXTRACT (QUARTER FROM DATE (app.start_date))) = 3
    GROUP BY country;

CREATE OR REPLACE VIEW ForthQuarterCommission AS
    SELECT DISTINCT SUM(c.commission), c.name as country FROM Accomodations as acc
    JOIN Application as app ON acc.id = app.accomodation_id
    JOIN Countries as c ON c.id = acc.country_id
    WHERE app.is_accepted = TRUE
    AND (EXTRACT (QUARTER FROM DATE (app.start_date))) = 4
    GROUP BY country;

SELECT tc.country as country_name, tc.sum as summary_commission, ROUND (100 * tc.sum / SUM(tc.sum) over()) as percentage,
ROUND ( 100 * coalesce(fqs.sum, 0) / SUM(tc.sum) over()) as first_quarter,
ROUND ( 100 * coalesce(sqs.sum, 0) / SUM(tc.sum) over()) as second_quarter,
ROUND ( 100 * coalesce(tqs.sum, 0) / SUM(tc.sum) over()) as third_quarter,
ROUND ( 100 * coalesce(fourthqs.sum, 0) / SUM(tc.sum) over()) as fourth_quarter
FROM TotalCommission as tc
LEFT JOIN FirstQuarterCommission as fqs ON tc.country = fqs.country
LEFT JOIN SecondQuarterCommission as sqs ON tc.country = sqs.country
LEFT JOIN ThirdQuarterCommission as tqs ON tc.country = tqs.country
LEFT JOIN ForthQuarterCommission as fourthqs ON tc.country = fourthqs.country;

