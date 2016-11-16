CREATE TABLE Countries(
	id SERIAL PRIMARY KEY, 
	name VARCHAR(255) not NULL, 
	commission INT
);

CREATE TABLE Facilities(
	id SERIAL PRIMARY KEY, 
	name VARCHAR(255) not NULL
);

CREATE TABLE EntertainmentsTypes(
	id SERIAL PRIMARY KEY, 
	name VARCHAR(255) UNIQUE
);

CREATE TABLE ReviewsCharacteristics(
	id SERIAL PRIMARY KEY, 
	name VARCHAR(255) not NULL
);

CREATE TABLE People(
	id SERIAL PRIMARY KEY, 
	name VARCHAR(255) not NULL, 
	second_name VARCHAR(255) not NULL, 
	e_mail VARCHAR(255) not NULL UNIQUE, 
	phone VARCHAR(255) not NULL UNIQUE, 
	sex VARCHAR(255) CHECK (sex in ('F', 'M')), 
	date_of_birth DATE, 
	photo VARCHAR(255) UNIQUE
);

CREATE TABLE Accomodations(
	id SERIAL PRIMARY KEY, 
	user_id INT references People, 
	country_id INT references Countries, 
	address VARCHAR(255) UNIQUE, 
	gps VARCHAR(255) UNIQUE, 
	description VARCHAR(255), 
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
	id SERIAL PRIMARY KEY, 
	accomodation_id INT references Accomodations, 
	review VARCHAR(255), 
	user_id INT references People, 
	reviewed_at TIMESTAMP not NULL

);

CREATE TABLE AccCharacteristics(
	id SERIAL PRIMARY KEY, 
	characteristic_id INT references ReviewsCharacteristics, 
	review_id INT references ReviewsAccomodation, 
	mark INT not NULL CHECK(mark <= 5 AND mark >= 1), 
	comment VARCHAR(255),
	UNIQUE(characteristic_id, review_id)
);

CREATE TABLE AccFacilities(
	id SERIAL PRIMARY KEY, 
	accomodation_id INT references Accomodations, 
	facility_id INT references Facilities
);

CREATE TABLE ReviewsResident(
	id SERIAL PRIMARY KEY, 
	author_id INT references People, 
	renter_id INT references People, 
	review VARCHAR(255), 
	mark INT not NULL CHECK(mark <= 5 AND mark >= 1)
);

CREATE TABLE Entertainments(
	id SERIAL PRIMARY KEY, 
	name VARCHAR(255), 
	gps VARCHAR(255), 
	start DATE, 
	finish DATE, 
	type_id INT references EntertainmentsTypes, 
	description VARCHAR(255)
);

CREATE TABLE Application(
	id SERIAL PRIMARY KEY, 
	user_id INT references People, 
	accomodation_id INT references Accomodations, 
	start_date DATE not NULL, 
	end_date DATE not NULL, 
	comment VARCHAR(255), 
	is_accepted BOOLEAN not NULL
);
