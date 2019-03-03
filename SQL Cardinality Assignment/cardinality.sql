DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS dorm_room CASCADE;
DROP TABLE IF EXISTS developer CASCADE;
DROP TABLE IF EXISTS workstation CASCADE;
DROP TABLE IF EXISTS pupil CASCADE;
DROP TABLE IF EXISTS assigned_seat CASCADE;
DROP TABLE IF EXISTS artist CASCADE;
DROP TABLE IF EXISTS painting CASCADE;
DROP TABLE IF EXISTS dorm_resident CASCADE;
DROP TABLE IF EXISTS patient CASCADE;
DROP TABLE IF EXISTS prescription CASCADE;
DROP TABLE IF EXISTS doctor CASCADE;
DROP TABLE IF EXISTS medication CASCADE;

CREATE TABLE dorm_room(
	building TEXT,
    number INT,
    PRIMARY KEY(building, number)
);

CREATE TABLE student(
	id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT  NOT NULL,
    dorm_room_building TEXT,
    dorm_room_number INT,
    FOREIGN KEY (dorm_room_building, dorm_room_number) REFERENCES dorm_room(building, number)
);


CREATE TABLE workstation(
	hostname TEXT NOT NULL PRIMARY KEY 
);

CREATE TABLE developer(
	first_name TEXT,
    last_name TEXT,
    workstation_hostname TEXT NOT NULL UNIQUE,
    PRIMARY KEY(first_name, last_name),
    FOREIGN KEY (workstation_hostname) REFERENCES workstation(hostname)
);

CREATE TABLE assigned_seat(
	number INT PRIMARY KEY
);

CREATE TABLE pupil(
	id INT PRIMARY KEY,
    name TEXT,
    assigned_seat_number INT UNIQUE,
    FOREIGN KEY (assigned_seat_number) REFERENCES assigned_seat(number)
);

CREATE TABLE artist(
	name TEXT PRIMARY KEY,
    year_born INT NOT NULL,
    year_died INT
);

CREATE TABLE painting(
	id INT,
    name TEXT,
    artist_name TEXT NOT NULL,
    FOREIGN KEY (artist_name) REFERENCES artist(name)
);

CREATE TABLE dorm_resident(
	id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    room_number INT,
    resident_assistant INT,
    FOREIGN KEY (resident_assistant) REFERENCES dorm_resident(id) 
);

CREATE TABLE doctor(
	id INT PRIMARY KEY,
    last_name TEXT NOT NULL
);

CREATE TABLE medication(
	name TEXT PRIMARY KEY
);

CREATE TABLE patient(
	id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL
);

CREATE TABLE prescription(
	patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    medication_name TEXT NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patient(id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(id),
    FOREIGN KEY (medication_name) REFERENCES medication(name)
);

