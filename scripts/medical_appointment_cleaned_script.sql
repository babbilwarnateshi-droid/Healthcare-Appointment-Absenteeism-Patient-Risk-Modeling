-- ==========================
-- DATA CLEANING --
-- ==========================

-- CREATE A DATABASE 'healthcare_analytics'  WHERE OUR TABLE 'medical_appointment_raw' WILL BE STORED.

CREATE DATABASE healthcare_analytics;
USE healthcare_analytics;

-- Dataset Check -- 
SELECT * FROM medical_appointment_raw
LIMIT 10;

-- Altering Column names for better navigation --
ALTER TABLE medical_appointment_raw
     CHANGE COLUMN Hipertension hypertension INT,
     CHANGE COLUMN Handcap disability_count INT,
	 CHANGE COLUMN `No-show` no_show VARCHAR(3);
     
-- Data Validation --
SELECT disability_count,
COUNT(*) FROM medical_appointment_raw
GROUP BY disability_count;
  
-- Date Checks  --
SELECT ScheduledDay, AppointmentDay
FROM medical_appointment_raw
LIMIT 10;

--  Below query will throw error --
ALTER TABLE medical_appointment_raw
     MODIFY COLUMN ScheduledDay DATETIME,
     MODIFY COLUMN AppointmentDay DATE;
     
 ALTER TABLE medical_appointment_raw
     ADD COLUMN ScheduledDay_clean DATETIME,
     ADD COLUMN AppointmentDay_clean DATE;
     
-- Set SQL safemode OFF --
SET SQL_SAFE_UPDATES = 0;
-- optional: SET SQL_SAFE_UPDATES = 1 --> To turn ON the safemode
     
--  We are going to update the data columns to Sequel friendly data  --
-- we do that by replacing the T & Z by empty spaces and arranging the date into (year-month-date) format
-- also the timestamp by (hour-min-sec) format
UPDATE medical_appointment_raw
     SET ScheduledDay_clean = STR_TO_DATE(REPLACE(REPLACE(
     ScheduledDay, 'T', ''), 'Z', ''), '%Y-%m-%d %H:%i:%s'),
	 AppointmentDay_clean = STR_TO_DATE(REPLACE(REPLACE(
     AppointmentDay, 'T', ''), 'Z', ''), '%Y-%m-%d %H:%i:%s');

-- Drop the uncleaned date columns--
ALTER TABLE medical_appointment_raw
     DROP COLUMN ScheduledDay,
     DROP COLUMN AppointmentDay;
     
-- Rename the Cleaned date Columns for better understanding --
ALTER TABLE medical_appointment_raw
     CHANGE COLUMN ScheduledDay_clean ScheduledDay DATETIME,
     CHANGE COLUMN AppointmentDay_clean AppointmentDay DATE;
     
-- Data Checks after updates --
SELECT ScheduledDay, AppointmentDay
FROM medical_appointment_raw
LIMIT 10;
     
-- Data checks for Age column --
SELECT 
    MIN(AGE),
    MAX(AGE)
FROM medical_appointment_raw;
-- ( Anomally identified i.e Negative Age is invalid)

-- Clear the anomally --
DELETE FROM medical_appointment_raw
WHERE AGE = -1;

-- Create a new field which shows the number of days between the booking of appointment and date of appointment --
ALTER TABLE medical_appointment_raw 
    ADD COLUMN lead_time_days INT;
    
UPDATE medical_appointment_raw 
SET lead_time_days = DATEDIFF(AppointmentDay, DATE(ScheduledDay));

-- Data Validation -- 
SELECT 
      MIN(lead_time_days),
      MAX(lead_time_days)
FROM medical_appointment_raw;


SELECT * FROM medical_appointment_raw
WHERE lead_time_days < 0;

-- remove the 5 invalid entries --
DELETE FROM medical_appointment_raw
WHERE lead_time_days < 0;

-- Data Validation Check --
SELECT * FROM medical_appointment_raw
WHERE lead_time_days < 0;

-- ==========================
-- DATA EXPLORATION --
-- ==========================

-- 1: What's our overall No_show rate?
SELECT no_show,
      COUNT(*) AS total_appointments,
      ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM medical_appointment_raw), 2)
      AS pct_of_total
      FROM medical_appointment_raw
      GROUP BY no_show;

-- 2: Does the day of the week matter?
SELECT DAYNAME(AppointmentDay) AS appointment_day,
COUNT(*) AS total_appointments,
SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) AS no_show,
ROUND(SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) 
AS rate_of_no_shows 
FROM medical_appointment_raw 
GROUP BY DAYNAME(AppointmentDay)
ORDER BY rate_of_no_shows DESC;

-- 3: Does the lead time matter?

-- Same Day
-- 1-3 Days
-- Within a week (4-7 Days)
-- Long lead (8+ Days)
	
SELECT
	CASE
		WHEN lead_time_days = 0 THEN 'Same Day'
        WHEN lead_time_days BETWEEN 1 AND 3 THEN 'Short (1-3 Days)'
		WHEN lead_time_days BETWEEN 4 AND 7 THEN 'Within a week'
        ELSE 'Long Lead (8+ days)'
	END AS lead_time_bucket, 
	COUNT(*) as total_appointments, 
	ROUND(SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS no_show_rate
FROM medical_appointment_raw
GROUP BY lead_time_bucket
ORDER BY no_show_rate DESC;

-- 4: Does the Age groups affects the no_show_rates?

-- child 0-12
-- teen (13-19)
-- young adult (20-39)
-- adult (40-59)

SELECT
	CASE
		WHEN Age BETWEEN 0 AND 12 THEN 'Child'
		WHEN Age BETWEEN 13 AND 19 THEN 'Teen'
        WHEN Age BETWEEN 20 AND 39 THEN 'Young Adult'
        WHEN Age BETWEEN 40 AND 59 THEN 'Adult'
		ELSE 'Senior'
	END AS age_group, 
    COUNT(*) AS total_appointments,
	ROUND(SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS no_show_rate
FROM medical_appointment_raw
GROUP BY age_group
ORDER BY no_show_rate DESC;

-- 5: Do SMS reminders help out people

SELECT
	CASE WHEN sms_received = 1 THEN 'Received SMS' ELSE 'No SMS' 
    END AS sms_status,
    COUNT(*) AS total_appointments,
	ROUND(SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS no_show_rate
FROM medical_appointment_raw
GROUP BY sms_status;

-- 6: Which neighborhoods have the highest risk? 

SELECT
	Neighbourhood, 
    COUNT(*) AS total_appointments, 
    ROUND(SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS no_show_rate, 
    RANK() OVER (ORDER BY ROUND(SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) DESC) AS risk_rank
	FROM medical_appointment_raw
    GROUP BY Neighbourhood
    HAVING COUNT(*) >= 100
    ORDER BY no_show_rate DESC
    LIMIT 15;
    
-- Patient-level risk scoring -- 

SELECT
	patientid, 
    appointmentid, 
    appointmentday, 
    no_show, 
    COUNT(*) OVER (
		PARTITION BY PatientID
        ORDER BY AppointmentDay
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS prior_appointments,
	SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) OVER 
		(PARTITION BY PatientID
        ORDER BY AppointmentDay
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS prior_no_shows
	FROM medical_appointment_raw
    ORDER BY patientid, appointmentday;
    
    
-- 

CREATE VIEW v_appointment_risk AS
WITH patient_history AS (
    SELECT
        PatientId,
        AppointmentID,
        AppointmentDay,
        Neighbourhood,
        lead_time_days,
        sms_received,
        Scholarship,
        no_show,
        COUNT(*) OVER (
            PARTITION BY PatientId 
            ORDER BY AppointmentDay 
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS prior_appointments,
        SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) OVER (
            PARTITION BY PatientId 
            ORDER BY AppointmentDay 
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS prior_no_shows
    FROM medical_appointment_raw
)
SELECT
    PatientId,
    AppointmentID,
    AppointmentDay,
    Neighbourhood,
    lead_time_days,
    prior_appointments,
    prior_no_shows,
    ROUND(prior_no_shows / NULLIF(prior_appointments, 0), 2) AS prior_no_show_rate,
    CASE
        WHEN prior_appointments = 0 THEN 'New Patient - Monitor'
        WHEN (prior_no_shows / NULLIF(prior_appointments, 0)) >= 0.5 
             OR lead_time_days >= 8 THEN 'High Risk'
        WHEN (prior_no_shows / NULLIF(prior_appointments, 0)) >= 0.2 
             OR lead_time_days BETWEEN 4 AND 7 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_tier
FROM patient_history;


-- Validate the query -- 
SELECT
* 
FROM v_appointment_risk
WHERE risk_tier = 'High Risk'
ORDER BY AppointmentDay
Limit 50;

--

-- run this query and save the file as csv, rename it as medical_appointment_cleaned 
SELECT * FROM medical_appointment_raw;
SELECT * FROM v_appointment_risk;