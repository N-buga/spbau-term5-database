CREATE TABLE People(id_person SERIAL PRIMARY KEY, name TEXT not NULL, second_name TEXT not NULL, e_mail TEXT not NULL UNIQUE, phone TEXT not NULL UNIQUE, sex TEXT CHECK (sex in ('F', 'M')), date_of_birth DATE, photo TEXT UNIQUE);
CREATE TABLE ReviewsResident(id_review SERIAL PRIMARY KEY, accomodation_id INT /*references Accomodations*/, review TEXT, mark INT not NULL CHECK(mark <= 5 AND mark >= 1));
CREATE TABLE Types(id_type SERIAL PRIMARY KEY, name TEXT UNIQUE);
CREATE TABLE Entertainments(id_entertainment SERIAL PRIMARY KEY, name TEXT, gps TEXT, start DATE, finish DATE, type_id INT references Types, description TEXT);

CREATE TABLE Characteristics(id_characteristic SERIAL PRIMARY KEY, name TEXT not NULL);
CREATE TABLE ReviewsAccomodation(id_review SERIAL PRIMARY KEY, accomodation_id INT /*references Accomodations*/, review TEXT not NULL, user_id INT references People, reviewed_at TIMESTAMP not NULL);
CREATE TABLE AccCharacteristics(id_acc_characteristic SERIAL PRIMARY KEY, characteristic_id INT references Characteristics, review_id INT references ReviewsAccomodation, mark INT not NULL CHECK(mark <= 5 AND mark >= 1), comment TEXT);
CREATE TABLE Application(id_application SERIAL PRIMARY KEY, user_id INT references People, accomodation_id INT /*references Accomodations*/, start_date DATE not NULL, end_date DATE not NULL, comment TEXT, is_accepted BOOLEAN not NULL);

