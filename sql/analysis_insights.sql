// Readmission Insights

//Top 10 diagnoses leading to readmissions <30 readmitted
SELECT diag_1, diag_2, diag_3, readmitted
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW;

select diagnosis_code, count(*) as readmit_count from (
select diag_1 as diagnosis_code from cleaned_diabetes_view 
where readmitted='<30' and diag_1 is not null

union all

select diag_2 as diagnosis_code from cleaned_diabetes_view 
where readmitted='<30' and diag_2 is not null

union all

select diag_3 as diagnosis_code from cleaned_diabetes_view 
where readmitted='<30' and diag_3 is not null
) as all_diagnoses 
group by diagnosis_code 
order by readmit_count desc
limit 10;

// Percentage of patients readmitted within 30 days
SELECT round(
    count_if(readmitted='<30')*100/count(*),2
) as percentage_of_readmitted_patients_within_30days
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW;

// Average time between discharge and readmission
SELECT 
    round(
avg(
case when 
    readmitted='<30' then 15 
    when readmitted='>30' then 45
    else NULL
    end),2
)
as estimated_avg_days_until_readmission
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
where readmitted in ('<30', '>30');

// Readmission rates by diagnosis (diag_1, diag_2, diag_3)
select diagnosis_code,
count(*) as total_patients,
sum(case when readmitted in ('>30','<30') then 1 else 0 end) as readmitted_patients,
round(100 * (sum(case when readmitted in ('>30','<30') then 1 else 0 end))/count(*),2) as readmission_rate_percent
from
(
SELECT diag_1 as diagnosis_code, readmitted 
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW

union all

SELECT diag_2 as diagnosis_code, readmitted 
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW

union all

SELECT diag_3 as diagnosis_code, readmitted 
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
) as all_diagnoses
group by diagnosis_code
order by readmission_rate_percent desc
limit 10;


// Patient Demographics

// Readmission trends by age group or gender
SELECT 
age,
count(*) as total_patients,
sum(case when readmitted in ('>30', '<30') then 1 else 0 end) as readmitted_patients_by_age,
round(
100*(sum(case when readmitted in ('>30', '<30') then 1 else 0 end))/count(*),2
) as readmission_rate_percent_by_age
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
group by age
order by age;

SELECT 
gender,
count(*) as total_patients,
sum(case when readmitted in ('>30','<30') then 1 else 0 end) as readmitted_patients_by_gender,
round(
100*(sum(case when readmitted in ('>30','<30') then 1 else 0 end))/count(*),2
) as readmission_rate_percent_by_gender
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
where gender in ('Male','Female')
group by gender
order by gender;

// Correlation between age and readmission
SELECT corr(
case age 
when '[0-10)' then 5
when '[10-20)' then 15
when '[20-30)' then 25
when '[30-40)' then 35
when '[40-50)' then 45
when '[50-60)' then 55
when '[60-70)' then 65
when '[70-80)' then 75
when '[80-90)' then 85
when '[90-100)' then 95
end,

case readmitted
when 'No' then 0
when '>30' then 1
when '<30' then 2
end
) as correlation_btw_age_and_readmission
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
where age is not null and readmitted is not null;

// Medication and Diagnosis Patterns

// Is insulin usage linked with readmissions?
SELECT insulin,
count(*) as total,
sum(case when readmitted='<30' then 1 else 0 end) as reamitted_within_30days_records,
round(100*(sum(case when readmitted='<30' then 1 else 0 end))/count(*),2) as readmitted_rate
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
group by insulin
order by readmitted_rate desc;

// Diabetes medication usage vs. readmission
SELECT diabetesmed,
count(*) as total,
sum(case when readmitted='<30' then 1 else 0 end) as reamitted_within_30days_records,
round(100*(sum(case when readmitted='<30' then 1 else 0 end))/count(*),2) as readmitted_rate
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
group by diabetesmed;

// Diagnosis codes with high readmission
SELECT 
diag_1,
count(*) as total,
sum(case when readmitted='<30' then 1 else 0 end) as reamitted_within_30days_records,
round(100*(sum(case when readmitted='<30' then 1 else 0 end))/count(*),2) as readmitted_rate
FROM HEALTHCARE_PROJECT.ANALYTICS.CLEANED_DIABETES_VIEW
group by diag_1
having total>50
order by readmitted_rate
limit 50;
