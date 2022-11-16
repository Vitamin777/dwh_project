
--DROP TABLE dim_calendar;

CREATE TABLE dim_calendar (
	id_calendar SERIAL PRIMARY KEY, 
	"date" date UNIQUE NOT NULL,
	day_week integer NOT NULL,
	"month" integer NOT NULL, 
	"year" integer NOT NULL);

DO $$
DECLARE
    i INTEGER = 0;
    T_DATE  date = '2017-01-01'; -- начальная дата
    E_DATE  date = '2030-12-31'; -- конечная дата
BEGIN
  WHILE (T_DATE+i)<=E_DATE 
  LOOP
    INSERT INTO dim_calendar ("date", day_week,"month","year") 
    VALUES (T_DATE+i, EXTRACT(isodow FROM T_DATE+i),EXTRACT(month FROM T_DATE+i),EXTRACT(year FROM T_DATE+i));
    i:= i + 1;
  END LOOP;
END $$;

--SELECT * FROM dim_calendar;

--DROP TABLE dim_airports;

CREATE TABLE dim_airports (
	airport_code varchar(3) PRIMARY KEY,
	airport_name_en varchar(100) NOT NULL,
	airport_name_ru varchar(100) NOT NULL,
	city_en varchar(60) NOT NULL,
	city_ru varchar(60) NOT NULL,
	longitude  double precision NOT NULL,
	latitude  double precision NOT NULL,
	timezone varchar(30) NOT NULL);

--SELECT * FROM dim_airports;

--DROP TABLE dim_passengers;

CREATE TABLE dim_passengers (
	passenger_id varchar(15) PRIMARY KEY,
	passenger_name varchar(30) NOT NULL,
	phone varchar(20) NOT NULL,
	email varchar(80));

--SELECT * FROM dim_passengers;

--DROP TABLE dim_aircrafts;

CREATE TABLE dim_aircrafts (
	aircraft_code varchar(3) PRIMARY KEY,
	model_en varchar(70) NOT NULL,
	model_ru varchar(70) NOT NULL,
	"range" integer NOT NULL);

--SELECT * FROM dim_aircrafts;

-- DROP TABLE dim_tariff;

CREATE TABLE dim_tariff (
	aircraft_code varchar(3) NOT NULL,
	seat_no varchar(3) NOT NULL,
    fare_conditions varchar(10) NOT NULL,
    PRIMARY KEY (aircraft_code, seat_no));
   
-- SELECT * FROM  dim_tariff;
   
-- DROP TABLE fact_flights;   
CREATE TABLE fact_flights (
	id_fact_flights SERIAL PRIMARY KEY,
	fk_aircraft_code varchar(3) NOT NULL,
	fk_seat_no varchar(3) NOT NULL,
	fk_passenger_id varchar(15) NOT NULL,
	fk_id_calendar integer NOT NULL,
	fk_departure_airport_code varchar(3) NOT NULL,
	fk_arrival_airport_code varchar(3) NOT NULL,
	passenger_name varchar(30) NOT NULL,
	actual_departure timestamp NOT NULL,
	actual_arrival timestamp NOT NULL,
	delay_departure integer NOT NULL,
	delay_arrival integer NOT NULL,
	aircraft_en varchar(70) NOT NULL, --model_en
	aircraft_ru varchar(70) NOT NULL, --model_ru
	departure_airport_en varchar(100) NOT NULL,
	departure_airport_ru varchar(100) NOT NULL,
	arrival_airport_en varchar(100) NOT NULL,
	arrival_airport_ru varchar(100) NOT NULL,
	fare_conditions varchar(10) NOT NULL,
	amount numeric(10,2) NOT NULL,
	FOREIGN KEY (fk_departure_airport_code) REFERENCES dim_airports(airport_code),
	FOREIGN KEY (fk_arrival_airport_code) REFERENCES dim_airports(airport_code),
	FOREIGN KEY (fk_id_calendar) REFERENCES dim_calendar(id_calendar),
	FOREIGN KEY (fk_passenger_id) REFERENCES dim_passengers(passenger_id),
	FOREIGN KEY (fk_aircraft_code) REFERENCES dim_aircrafts(aircraft_code),
	FOREIGN KEY (fk_aircraft_code, fk_seat_no) REFERENCES dim_tariff(aircraft_code,seat_no)
);   
   
--  SELECT * FROM  fact_flights;  
