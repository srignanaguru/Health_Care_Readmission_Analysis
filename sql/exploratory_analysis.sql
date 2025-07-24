// Normal Insights for readmission within 30 days

// Relationship Between Number of Medications and Time in Hospital
SELECT num_medications, round(avg(time_in_hospital),2) as avg_stay
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
group by num_medications
order by num_medications;

// Insulin Usage Patterns
SELECT insulin, count(*) as total
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
group by insulin
order by total desc;

// Admission Source of visits
SELECT admission_source, count(*) as total_admissions
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
group by admission_source
order by total_admissions desc;

// Readmission Behaviour by Admission Source
SELECT admission_source,
count(*) as total_admissions,
sum(case when readmitted='<30' then 1 else 0 end) as readmit_30,
sum(case when readmitted='>30' then 1 else 0 end) as readmit_over_30,
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
group by admission_source
order by readmit_30 desc;

// Discharge disposition vs. Readmission
SELECT discharge_disposition,
count(*) as total,
sum(case when readmitted='<30' then 1 else 0 end) as readmit_30
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
group by discharge_disposition
order by readmit_30 desc;

// Elderly Patients on Insulin
SELECT *
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
where age in ('[70-80)', '[80-90)', '[90-100)') and insulin <> 'No';