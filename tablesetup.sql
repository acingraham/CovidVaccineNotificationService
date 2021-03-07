CREATE TABLE users (
	id                INT GENERATED ALWAYS AS IDENTITY UNIQUE,
    phone             TEXT NOT NULL,
    email	          TEXT,
    dob 	      	  DATE,
    zip               varchar(10),
    gender            varchar(20),
    livesInNY         boolean,
    worksInNY         boolean,
    vaccineEligible   boolean NOT NULL DEFAULT FALSE
);

CREATE TABLE locations (
	id     INT GENERATED ALWAYS AS IDENTITY UNIQUE,
    name   varchar(4000) NOT NULL
);

CREATE TABLE userlocations (
	locationId INT NOT NULL,
	userId INT NOT NULL,
	CONSTRAINT fk_location
      FOREIGN KEY(locationId) 
	  REFERENCES locations(id),
	CONSTRAINT fk_user
      FOREIGN KEY(userId) 
	  REFERENCES users(id)
);

CREATE TABLE notifications (
	id                 INT GENERATED ALWAYS AS IDENTITY,
	locationId         INT NOT NULL,
	userId             INT NOT NULL,
	ts                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	CONSTRAINT fk_location
      FOREIGN KEY(locationId) 
	  REFERENCES locations(id),
	CONSTRAINT fk_user
      FOREIGN KEY(userId) 
	  REFERENCES users(id)
);

-- CONVERT Locations to locationIds

WITH ins1 AS (
   INSERT INTO users (phone)
   VALUES ('fai55')
-- ON     CONFLICT DO NOTHING         -- optional addition in Postgres 9.5+
   RETURNING id AS userId
   )
, ins2 AS (
   INSERT INTO userLocations (userId, adddetails)
   SELECT userId, 'ss' FROM ins1
   RETURNING user_id
   )
, ins3 AS (
   SELECT userId, 'ss' FROM ins1
   RETURNING user_id
   )
INSERT INTO sample2 (user_id, value)
SELECT user_id, 'ss2' FROM ins2;









INSERT INTO locations(name) VALUES ('');

INSERT INTO locations(name) VALUES ('Javits Center (New York, NY)');
INSERT INTO locations(name) VALUES ('Jones Beach - Field 3 (Wantagh, NY)');
INSERT INTO locations(name) VALUES ('State Fair Expo Center: NYS Fairgrounds (Syracuse, NY)');
INSERT INTO locations(name) VALUES ('SUNY Albany  (Albany, NY)');
INSERT INTO locations(name) VALUES ('Westchester County Center (White Plains, NY)');
INSERT INTO locations(name) VALUES ('SUNY Stony Brook University Innovation and Discovery Center (Stony Brook, NY)');
INSERT INTO locations(name) VALUES ('SUNY Potsdam Field House (Potsdam, NY)');
INSERT INTO locations(name) VALUES ('Aqueduct Racetrack - Racing Hall (South Ozone Park, NY)');
INSERT INTO locations(name) VALUES ('Plattsburgh International Airport -Connecticut Building (Plattsburgh, NY)');
INSERT INTO locations(name) VALUES ('SUNY Binghamton (Johnson City, NY)');
INSERT INTO locations(name) VALUES ('SUNY Polytechnic Institute - Wildcat Field House (Utica, NY)');
INSERT INTO locations(name) VALUES ('University at Buffalo South Campus - Harriman Hall (Buffalo, NY)');
INSERT INTO locations(name) VALUES ('Rochester Dome Arena (Henrietta, NY)');





  select id, name from locations
  where name in ('Javits Center (New York, NY)', 'SUNY Albany  (Albany, NY)')

covidvaccinationnotification is the database name
