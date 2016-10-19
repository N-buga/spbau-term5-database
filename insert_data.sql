--Fill EntertainmentsTypes table
INSERT INTO EntertainmentsTypes VALUES (1, 'festival');
INSERT INTO EntertainmentsTypes VALUES (2, 'beach');
INSERT INTO EntertainmentsTypes VALUES (3, 'concert');
INSERT INTO EntertainmentsTypes VALUES (4, 'exhibition');

--Fill ReviewsCharacteristics table
INSERT INTO ReviewsCharacteristics VALUES (1, 'location');
INSERT INTO ReviewsCharacteristics VALUES (2, 'cleanliness');
INSERT INTO ReviewsCharacteristics VALUES (3, 'communication');
INSERT INTO ReviewsCharacteristics VALUES (4, 'accuracy');
INSERT INTO ReviewsCharacteristics VALUES (5, 'arrival');


--Fill Countries table
INSERT INTO Countries VALUES (1, 'Russia');
INSERT INTO Countries VALUES (2, 'United Kingdom');
INSERT INTO Countries VALUES (3, 'USA');
INSERT INTO Countries VALUES (4, 'Finland');
INSERT INTO Countries VALUES (5, 'Germany');
INSERT INTO Countries VALUES (6, 'Italy');
INSERT INTO Countries VALUES (7, 'Spain');
INSERT INTO Countries VALUES (8, 'Canada');
INSERT INTO Countries VALUES (9, 'Switzerland');

--Fill Facilities table
INSERT INTO Facilities VALUES (1, 'Internet');
INSERT INTO Facilities VALUES (2, 'Washer');
INSERT INTO Facilities VALUES (3, 'Hair dryer');
INSERT INTO Facilities VALUES (4, 'Iron');
INSERT INTO Facilities VALUES (5, 'Kitchen');
INSERT INTO Facilities VALUES (6, 'Elevator');
INSERT INTO Facilities VALUES (7, 'Wireless internet');
INSERT INTO Facilities VALUES (8, 'Air conditioning');

--Fill People table
INSERT INTO People VALUES (1, 'Maria', 'Ivanova', 'mashka_11@mail.ru', '123-45-67', 'F', '1995-10-29');
INSERT INTO People VALUES (2, 'Elizabeth', 'Ivanishina', 'lizzy_iv@mail.ru', '135-95-67', 'F', '1992-08-09');
INSERT INTO People VALUES (3, 'Marina', 'Colmanova', 'mariena_one@gmail.com', '123-25-64', 'F', '1990-01-17');
INSERT INTO People VALUES (4, 'Helen', 'Ivinitch', 'helena_beauty@inbox.ru', '381-40-07', 'F', '1980-11-10');
INSERT INTO People VALUES (5, 'Ann', 'Black', 'ann_black@mail.ru', '489-45-17', 'F', '1976-03-21');
INSERT INTO People VALUES (6, 'Tamara', 'Korneva', 'korneva_t_a@mail.ru', '100-00-67', 'F', '1995-12-14');
INSERT INTO People VALUES (7, 'Michael', 'Levitsky', 'mich_lev@yandex.ru', '123-00-67', 'M', '1985-08-09');
INSERT INTO People VALUES (8, 'John', 'Ivanov', 'johny_sweet@gmail.com', '987-45-67', 'M', '1978-04-17');
INSERT INTO People VALUES (9, 'Jacob', 'Black', 'the_best_werewolf@gmail.com', '837-03-93', 'M', '1988-02-20');
INSERT INTO People VALUES (10, 'Peter', 'King', 'pancakes.forever@gmail.com', '937-38-75', 'M', '1991-06-12');

--Fill Accomodations table
INSERT INTO Accomodations VALUES (1, 1, 1, 'SPb, 197823, Gagarina str., 30-124', '55,755831; 67,617673', 'Smal but very cosy flat with a beautiful view', 1, 1, 2, 500); -- A Maria's flat in Russia
INSERT INTO Accomodations VALUES (2, 10, 7, 'Barcelona, d/en Boquer, 6', '41,174900; 02,044200', 'Very nice appartment', 1, 2, 4, 750); -- A Peter's flat in Spain
INSERT INTO Accomodations VALUES (3, 6, 2, 'London, Oxford street, 2', NULL, 'Luxury modern flat', 3, 4, 4, 1500);

--Fill WeeklyCost table
INSERT INTO WeeklyCost VALUES (1, 1, 2500);
INSERT INTO WeeklyCost VALUES (1, 2, 2400);
INSERT INTO WeeklyCost VALUES (1, 15, 1500);
INSERT INTO WeeklyCost VALUES (1, 25, 3000);
INSERT INTO WeeklyCost VALUES (2, 1, 3000);
INSERT INTO WeeklyCost VALUES (3, 1, 12000);
INSERT INTO WeeklyCost VALUES (3, 25, 15000);

--Fill AccFacilities table
INSERT INTO AccFacilities VALUES (1, 1, 1);
INSERT INTO AccFacilities VALUES (2, 1, 2);
INSERT INTO AccFacilities VALUES (3, 1, 3);
INSERT INTO AccFacilities VALUES (4, 1, 4);
INSERT INTO AccFacilities VALUES (5, 1, 5);
INSERT INTO AccFacilities VALUES (6, 1, 6);
INSERT INTO AccFacilities VALUES (7, 1, 7);
INSERT INTO AccFacilities VALUES (8, 1, 8);
INSERT INTO AccFacilities VALUES (9, 2, 1);
INSERT INTO AccFacilities VALUES (10, 2, 3);
INSERT INTO AccFacilities VALUES (11, 2, 5);
INSERT INTO AccFacilities VALUES (12, 2, 6);
INSERT INTO AccFacilities VALUES (13, 3, 1);
INSERT INTO AccFacilities VALUES (14, 3, 4);
INSERT INTO AccFacilities VALUES (15, 3, 8);

--Fill Entertainments table

