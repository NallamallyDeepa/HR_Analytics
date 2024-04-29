SELECT * FROM hr_analytics.hr_1;
select * from hr_1;
select * from hr_2;
ALTER TABLE hr_1
ADD COLUMN Attrition_Rate int;

-- Update new column based on condition
UPDATE hr_1
SET Attrition_Rate = CASE
                           WHEN Attrition ="YES" THEN 1
                           ELSE 0
                       END;
set sql_safe_updates=0; 

--   kpi 1  -- average attrition rate for all departments

select department,
		concat(round(avg(attrition_rate)*100,2),"%") 
		as Attrition_Rate_percentage 
        from hr_1 
        group by department; 

-- kpi 2 -- average hourly rate of male research scientist
   
select jobrole,gender,
    avg(hourlyrate)
    from hr_1 
    group by jobrole,gender 
    having jobrole="research scientist"and gender="male";

-- kpi 3 -- attrition rate vs monthly income stats

select floor(monthlyincome/10000)*10000 
   as income_bin ,
   concat(round(avg(attrition_rate)*100,2),"%") as attrition_rate
   from  hr_1 inner join hr_2 
   on hr_1.EmployeeNumber = hr_2.`Employee ID`
   group by income_bin 
   order by income_bin ;

-- kpi 4 -- average working years for each department

select department,
   round(avg(totalworkingyears),2) 
   as avg_working_years 
   from hr_1 join hr_2 
   on hr_1.employeenumber=hr_2.`employee id` 
   group by department;

-- kpi 5 -- job role vs work life balance

SELECT jobrole,
    CASE 
        WHEN (SUM(CASE WHEN worklifebalance IN (1, 2) THEN 1 ELSE 0 END)) <
             (SUM(CASE WHEN worklifebalance IN (3, 4) THEN 1 ELSE 0 END))
        THEN 'Excellent'
        ELSE 'Average'
        END AS worklifebalance,COUNT(worklifebalance) FROM hr_1 JOIN hr_2 
        ON hr_1.employeenumber=hr_2.`employee id` GROUP BY jobrole ORDER BY jobrole;

-- kpi 6 -- attrition rate vs years since last promotion

select floor(yearssincelastpromotion/5)*5 as years_since_last_promotion, 
    concat(round(avg(attrition_rate)*100,2),"%") as attrition_rate
    from hr_1 join hr_2 
    on hr_1.EmployeeNumber= hr_2.`Employee ID`
    group by years_since_last_promotion order by years_since_last_promotion;
    
    
    
    
    
    
    
    