CREATE TABLE Countries(
	id_country SERIAL PRIMARY KEY, 
	name TEXT not NULL, 
	commission INT
);

CREATE TABLE Facilities(
	id_facility SERIAL PRIMARY KEY, 
	name TEXT not NULL
);

CREATE TABLE EntertainmentsTypes(
	id_type SERIAL PRIMARY KEY, 
	name TEXT UNIQUE
);

CREATE TABLE ReviewsCharacteristics(
	id_characteristic SERIAL PRIMARY KEY, 
	name TEXT not NULL
);

CREATE TABLE People(
	id_person SERIAL PRIMARY KEY, 
	name TEXT not NULL, 
	second_name TEXT not NULL, 
	e_mail TEXT not NULL UNIQUE, 
	phone TEXT not NULL UNIQUE, 
	sex TEXT CHECK (sex in ('F', 'M')), 
	date_of_birth DATE, 
	photo TEXT UNIQUE
);

CREATE TABLE Accomodations(
	id_accomodation SERIAL PRIMARY KEY, 
	user_id INT references People, 
	country_id INT references Countries, 
	address TEXT UNIQUE, 
	gps TEXT UNIQUE, 
	description TEXT, 
	rooms_amount INT CHECK (rooms_amount >= 1), 
	beds_amount INT CHECK (beds_amount >= 0), 
	max_residents INT CHECK (max_residents >= 1), 
	clening_cost INT
);

CREATE TABLE WeeklyCost(
	accomodation_id INT references Accomodations, 
	week_number INT not NULL, 
	price INT,
	PRIMARY KEY (accomodation_id, week_number)
);

CREATE TABLE ReviewsAccomodation(
	id_review SERIAL PRIMARY KEY, 
	accomodation_id INT references Accomodations, 
	review TEXT, 
	user_id INT references People, 
	reviewed_at TIMESTAMP not NULL

);

CREATE TABLE AccCharacteristics(
	id_acc_characteristic SERIAL PRIMARY KEY, 
	characteristic_id INT references ReviewsCharacteristics, 
	review_id INT references ReviewsAccomodation, 
	mark INT not NULL CHECK(mark <= 5 AND mark >= 1), 
	comment TEXT,
	UNIQUE(characteristic_id, review_id)
);

CREATE TABLE AccFacilities(
	id_acc_facility SERIAL PRIMARY KEY, 
	accomodation_id INT references Accomodations, 
	facility_id INT references Facilities
);

CREATE TABLE ReviewsResident(
	id_review SERIAL PRIMARY KEY, 
	author_id INT references People, 
	renter_id INT references People, 
	review TEXT, 
	mark INT not NULL CHECK(mark <= 5 AND mark >= 1)
);

CREATE TABLE Entertainments(
	id_entertainment SERIAL PRIMARY KEY, 
	name TEXT, 
	gps TEXT, 
	start DATE, 
	finish DATE, 
	type_id INT references EntertainmentsTypes, 
	description TEXT
);

CREATE TABLE Application(
	id_application SERIAL PRIMARY KEY, 
	user_id INT references People, 
	accomodation_id INT references Accomodations, 
	start_date DATE not NULL, 
	end_date DATE not NULL, 
	comment TEXT, 
	is_accepted BOOLEAN not NULL
);
