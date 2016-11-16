CREATE INDEX on WeeklyCost(week_number);
CREATE INDEX on Accomodations(max_residents);
CREATE INDEX on Countries(name);

CREATE OR REPLACE VIEW Country_week_resid_acc
AS
SELECT A.*
FROM Accomodations A 
JOIN WeeklyCost WC ON A.id = WC.accomodation_id
JOIN Countries C ON A.country_id = C.id
WHERE WC.week_number = 1 AND A.max_residents >=6 AND C.name = 'Spain';

prepare plan1 as 
SELECT * FROM Country_week_resid_acc
EXCEPT
SELECT CWRA.*
FROM Country_week_resid_acc CWRA 
JOIN AccFacilities AF ON CWRA.id = AF.accomodation_id
JOIN Facilities F ON F.id = AF.facility_id
WHERE F.name = 'Wi-Fi';
