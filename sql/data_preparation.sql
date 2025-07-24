create database healthcare_project;
use database healthcare_project;

create schema analytics;
use schema analytics;

// Table Creation
CREATE TABLE diabetes_data (
encounter_id BIGINT,
patient_nbr BIGINT,
race STRING,
gender STRING,
age STRING,
admission_type_id INT,
discharge_disposition_id INT,
admission_source_id INT,
time_in_hospital INT,
num_lab_procedures INT,
num_procedures INT,
num_medications INT,
number_outpatient INT,
number_emergency INT,
number_inpatient INT,
diag_1 STRING,
diag_2 STRING,
diag_3 STRING,
number_diagnoses INT,
insulin STRING,
change STRING,
diabetesMed STRING,
readmitted STRING
);

CREATE TABLE id_mapping (
id INT,
description STRING,
type STRING
);

SELECT
  d.encounter_id,
  d.patient_nbr,
  d.race,
  d.gender,
  d.age,
  atm.description AS admission_type,
  ddm.description AS discharge_disposition,
  asm.description AS admission_source,
  d.time_in_hospital,
  d.num_lab_procedures,
  d.num_procedures,
  d.num_medications,
  d.number_outpatient,
  d.number_emergency,
  d.number_inpatient,
  d.diag_1,
  d.diag_2,
  d.diag_3,
  d.number_diagnoses,
  d.insulin,
  d.change,
  d.diabetesMed,
  d.readmitted
FROM
  "HEALTHCARE_PROJECT"."ANALYTICS"."DIABETES_DATA" d
LEFT JOIN "HEALTHCARE_PROJECT"."ANALYTICS"."ID_MAPPING" atm 
  ON d.admission_type_id = atm.id AND atm.type = 'admission_type_id'
LEFT JOIN "HEALTHCARE_PROJECT"."ANALYTICS"."ID_MAPPING" ddm 
  ON d.discharge_disposition_id = ddm.id AND ddm.type = 'discharge_disposition_id'
LEFT JOIN "HEALTHCARE_PROJECT"."ANALYTICS"."ID_MAPPING" asm 
  ON d.admission_source_id = asm.id AND asm.type = 'admission_source_id';


CREATE OR REPLACE VIEW HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW AS
SELECT
  d.encounter_id,
  d.patient_nbr,
  d.race,
  d.gender,
  d.age,
  atm.description AS admission_type,
  ddm.description AS discharge_disposition,
  asm.description AS admission_source,
  d.time_in_hospital,
  d.num_lab_procedures,
  d.num_procedures,
  d.num_medications,
  d.number_outpatient,
  d.number_emergency,
  d.number_inpatient,
  d.diag_1,
  d.diag_2,
  d.diag_3,
  d.number_diagnoses,
  d.insulin,
  d.change,
  d.diabetesMed,
  d.readmitted
FROM
  "HEALTHCARE_PROJECT"."ANALYTICS"."DIABETES_DATA" d
LEFT JOIN "HEALTHCARE_PROJECT"."ANALYTICS"."ID_MAPPING" atm 
  ON d.admission_type_id = atm.id AND atm.type = 'admission_type_id'
LEFT JOIN "HEALTHCARE_PROJECT"."ANALYTICS"."ID_MAPPING" ddm 
  ON d.discharge_disposition_id = ddm.id AND ddm.type = 'discharge_disposition_id'
LEFT JOIN "HEALTHCARE_PROJECT"."ANALYTICS"."ID_MAPPING" asm 
  ON d.admission_source_id = asm.id AND asm.type = 'admission_source_id';

SELECT * FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW;