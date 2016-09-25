CREATE TABLE People(id_person SERIAL PRIMARY KEY, name TEXT not NULL, second_name TEXT not NULL, e_mail TEXT not NULL UNIQUE, phone TEXT not NULL UNIQUE, sex TEXT CHECK (sex in ('F', 'M')), date_of_birth DATE, photo TEXT UNIQUE);
CREATE TABLE ReviewsResident(id_review SERIAL PRIMARY KEY, accomodation_id INT /*references Accomodations*/, review TEXT, mark INT not NULL CHECK(mark <= 5 AND mark >= 1));
CREATE TABLE Types(id_type SERIAL PRIMARY KEY, name TEXT UNIQUE);
CREATE TABLE Entertainments(id_entertainment SERIAL PRIMARY KEY, name TEXT, gps TEXT, start DATE, finish DATE, type_id INT references Types, description TEXT);

