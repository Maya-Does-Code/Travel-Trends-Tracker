-- This database will be used to help a travel agency track trends from a small selection of their travellers.  

Create database TRAVEL_TRENDS;

Use TRAVEL_TRENDS;

CREATE TABLE traveller_type (
    traveller_id INT AUTO_INCREMENT PRIMARY KEY,
    age_group VARCHAR(50),
    traveller_type VARCHAR(50)
);

ALTER TABLE traveller_type RENAME TO traveller_profile; -- I changed the name of the table to avoid confusion as there's a column with the same name.

INSERT INTO traveller_profile (age_group, traveller_type)
VALUES
 ('25-35','group'),
  ('25-35','group'),
  ('40-60','solo'),
  ('18-25','group'),
  ('25-35','couple'),
  ('18-25','group'),
  ('18-25','solo'),
  ('18-25','couple'),
  ('40-60','couple'),
  ('60+','solo');

SELECT * FROM traveller_profile;

CREATE TABLE holiday_type (
    holiday_id INT AUTO_INCREMENT PRIMARY KEY,
    holiday_type VARCHAR(50),
    budget VARCHAR(50) NOT NULL,
    duration INT NOT NULL,
    CHECK(duration > 0));

INSERT INTO holiday_type (holiday_type, budget, duration)
VALUES
  ('party','Under 300',2),
  ('culture','300-500',5),
  ('culture','800+',7),
  ('adventure','500-700',8),
  ('party','Under 300',3),
  ('adventure','800+',6),
  ('rest','500-700',10),
  ('adventure','Under 300',3),
  ('culture','800+',14),
  ('party','300-500',6);

  
SELECT * FROM holiday_type;

SELECT * FROM traveller_profile
ORDER BY traveller_id;
  
SELECT * FROM holiday_type
ORDER BY budget DESC;

CREATE TABLE trips_taken (
    trip_id INT AUTO_INCREMENT PRIMARY KEY,
    traveller_id INT,
    holiday_id INT, 
    destination VARCHAR(50) NOT NULL,
    country VARCHAR(50) NULL,
	total_cost DECIMAL(10,2),
    FOREIGN KEY (traveller_id) REFERENCES traveller_profile(traveller_id),
    FOREIGN KEY (holiday_id) REFERENCES holiday_type(holiday_id)
);

INSERT INTO trips_taken (traveller_id, holiday_id, destination, country, total_cost)
VALUES 
(1,1,'Lisbon', 'Portugal', 250.00),
(2,2,'Krakow',NULL, 454.90),
(3,3,'Auckland', 'New Zealand', 1100.00),
(4,4,'Vancouver', 'Canada', 699.99),
(5,5,'Dublin',NULL, 290.50),
(6,6,'Cape Town','South Africa', 955.60),
(7,7,'Madeira','Portugal', 600.00),
(8,8,'Istanbul','Turkey', 280.00),
(9,9,'Kingston','Jamaica', 2000.00),
(10,10, 'Paris',NULL, 490.90);

SELECT * FROM trips_taken
ORDER BY total_cost;

-- LEFT JOIN
SELECT TP.*, TT.*
FROM traveller_profile AS TP
	LEFT JOIN trips_taken AS TT
    ON TP.traveller_id = TT.traveller_id;
    
 -- INNER JOIN, EXCLUDING ANY NULL VALUES
SELECT HT.holiday_id, HT.budget, TT.trip_id, TT.destination, TT.total_cost
FROM holiday_type AS HT
	INNER JOIN trips_taken AS TT
    ON HT.holiday_id = TT.holiday_id 
    WHERE country IS NOT NULL;
    
-- Find out the average cost per day for those who travelled solo    
SELECT ROUND(TT.total_cost / HT.duration, 2) AS Average_Daily_Cost_Solo
FROM trips_taken AS TT, holiday_type AS HT, traveller_profile AS TP
WHERE TT.holiday_id = HT.holiday_id AND TT.traveller_id = TP.traveller_id
AND TP.traveller_type = 'solo';

-- Count holiday types with a budget less than £800
SELECT COUNT(budget)
FROM holiday_type AS HT
WHERE budget <> '800+';

SELECT AVG(total_cost) AS AverageTripCost
FROM trips_taken;

-- SELECT CONCAT(destination, ', ', country)
-- FROM trips_taken;

DELIMITER //

CREATE PROCEDURE ShowUniqueDestinations()
BEGIN
	SELECT DISTINCT destination FROM trips_taken;
END //

DELIMITER ;

CALL ShowUniqueDestinations();
