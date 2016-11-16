--1. 
CREATE OR REPLACE VIEW Country_week_resid_acc
AS
SELECT A.*
FROM Accomodations A 
JOIN WeeklyCost WC ON A.id = WC.accomodation_id
JOIN Countries C ON A.country_id = C.id
WHERE WC.week_number = 1 AND A.max_residents >=6 AND C.name = 'Spain';

SELECT * FROM Country_week_resid_acc
EXCEPT
SELECT CWRA.*
FROM Country_week_resid_acc CWRA 
JOIN AccFacilities AF ON CWRA.id = AF.accomodation_id
JOIN Facilities F ON F.id = AF.facility_id
WHERE F.name = 'Wi-Fi';

--2.
CREATE OR REPLACE VIEW Hosts AS
    SELECT DISTINCT acc.user_id as host_id FROM Accomodations as acc;

CREATE OR REPLACE VIEW Renters AS
    SELECT DISTINCT app.user_id as renter_id FROM Application as app
    WHERE app.is_accepted = TRUE;

SELECT p.name, p.second_name from People as p
JOIN Hosts as h ON h.host_id = p.id
JOIN Renters as r ON r.renter_id = p.id;

--3.
CREATE OR REPLACE VIEW BookingStat AS
    SELECT COUNT(app.user_id) as bookings_amount, app.accomodation_id as acc_id FROM Application as app
    WHERE app.is_accepted = TRUE
    GROUP BY acc_id;

CREATE OR REPLACE VIEW PopularAcc AS
    SELECT bs.acc_id FROM BookingStat as bs
    WHERE bs.bookings_amount >= 10;

SELECT p.name, p.second_name FROM People as p
JOIN Accomodations as acc ON p.id = acc.user_id
WHERE acc.id NOT IN (SELECT acc_id FROM PopularAcc);

--4. 
SELECT A.id, COALESCE (C.commission, 0)
+ 7 * sum (COALESCE (WC.price, 0))
+ COALESCE (Ac.clening_cost, 0)
- (EXTRACT(ISODOW FROM DATE(A.start_date)) - 1)* COALESCE ((SELECT wc.price FROM WeeklyCost as WC
    JOIN Accomodations as Ac ON Ac.id = WC.accomodation_id
    JOIN Application as A ON Ac.id = A.accomodation_id
    WHERE A.is_accepted = TRUE
    AND WC.week_number = EXTRACT(WEEK FROM DATE(A.start_date))), 0)
-(7 - EXTRACT(ISODOW FROM DATE(A.end_date)))* COALESCE ((SELECT wc.price FROM WeeklyCost as WC
    JOIN Accomodations as Ac ON Ac.id = WC.accomodation_id
    JOIN Application as A ON Ac.id = A.accomodation_id
    WHERE A.is_accepted = TRUE
    AND WC.week_number = EXTRACT(WEEK FROM DATE(A.end_date))), 0)
as cost FROM People P
JOIN Application A ON P.id = A.user_id
JOIN WeeklyCost WC ON A.accomodation_id = WC.accomodation_id
JOIN Accomodations Ac ON Ac.id = A.accomodation_id
JOIN Countries C ON C.id = Ac.country_id
WHERE (CASE EXTRACT(WEEK FROM DATE(A.start_date)) - EXTRACT(WEEK FROM DATE(A.end_date)) <= 0
WHEN TRUE THEN
    WC.week_number BETWEEN EXTRACT(WEEK FROM DATE(A.start_date)) AND EXTRACT(WEEK FROM DATE(A.end_date))
ELSE
    WC.week_number <= EXTRACT(WEEK FROM DATE(A.end_date)) OR WC.week_number >= EXTRACT(WEEK FROM DATE(A.start_date)) END)
AND
    A.is_accepted = TRUE
GROUP BY A.id, C.id, Ac.id;



--5.
SELECT A.id, AVG(C.mark)
FROM Accomodations as A
JOIN ReviewsAccomodation as R ON A.id = R.accomodation_id
JOIN AccCharacteristics as C ON R.id = C.review_id
GROUP BY (A.id);

--6.
SELECT C.name, COUNT(*)
FROM Countries as C
JOIN Accomodations as A ON C.id = A.country_id
GROUP BY C.id;

--7. 

CREATE OR REPLACE FUNCTION _final_median(NUMERIC[])
   RETURNS NUMERIC AS
$$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;

DROP AGGREGATE IF EXISTS median(NUMERIC) CASCADE;

CREATE AGGREGATE median(NUMERIC) (
  SFUNC=array_append,
  STYPE=NUMERIC[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);

CREATE OR REPLACE VIEW Median_country_week AS
SELECT C.id, C.name, WC.week_number,  MEDIAN(COALESCE(C.commission, 0) +  7*COALESCE(WC.price, 0) + COALESCE(A.clening_cost, 0)) as median_cost
FROM Accomodations A
JOIN Countries C ON A.country_id = C.id
JOIN WeeklyCost WC ON WC.accomodation_id = A.id
GROUP BY C.id, WC.week_number
ORDER BY C.id;

SELECT * FROM Median_country_week;

--8. 
SELECT id, week_number 
FROM
(SELECT id, week_number, median_cost, 
MAX(median_cost) OVER(PARTITION BY id) as max_m_cost
FROM Median_country_week) AS With_max
WHERE 2*median_cost < max_m_cost;

--9.
CREATE OR REPLACE VIEW TotalCommission AS
    SELECT DISTINCT SUM(c.commission), c.name as country FROM Accomodations as acc
    JOIN Application as app ON acc.id = app.accomodation_id
    JOIN Countries as c ON c.id = acc.country_id
    WHERE app.is_accepted = TRUE
    GROUP BY country;

SELECT TotalCommission.country as country_name, 
   TotalCommission.sum as summary_commission, 
   ROUND (100 * sum / SUM(sum) over()) as percentage FROM TotalCommission;

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

