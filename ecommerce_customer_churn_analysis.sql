select *from customer_churn;

--Total unique customers.
select count(distinct customer_id)
from customer_churn;

--Total churned customer.
select count(distinct customer_id) as n_of_churn
from customer_churn
where churn =1;

--Total revenue generated.
select sum(product_price * quantity) as revenue
from customer_churn;

--Revenue loss due to return orders.
with cte as(
       select sum(product_price * quantity)as revenue,
       sum(product_price * quantity) filter(where returns = 1) as return_cost
       from customer_churn
	   )
select (revenue - return_cost) as revenue_loss from cte; 

--Average order value 
 --# Average amount of money customers pay per order
with ave_order as(
       select sum(product_price * quantity) as revenue,
       count(*) as total_orders from customer_churn)
select revenue / total_orders as AOV from ave_order;

--Average Purchase frequency.
select round(avg(purchase_frequency),2)
from(
       select customer_id, 
       count (purchase_date) as purchase_frequency
from customer_churn--average purchase frequency 
select round(avg(frequently),2) as frequency
from(
    select distinct customer_id, count(purchase_date) as frequently from customer_churn
    group by 1
    having count(purchase_date)>1
    );

--A. Churn Analysis:
--1.Customer Churn rate.
select
round(count(distinct customer_id)
      filter (where churn_type = 'Churn')::numeric /
      count(distinct customer_id) *100.0,2)
from customer_churn;

--2.Churn risk customer list.
 --Customers who have not ordered in interval of 2 year from their last purchases, consider as risk customer.
select customer_id,
customer_name
from customer_churn
where churn= 0
group by 1,2 
having max(purchase_date) < (select max(purchase_date)- interval '2 years'
                              from customer_churn);
	  
--3. Churn rate by age group.
    --Which age group most likely to churn?
    --the percentage represent rate of age group that churned in that age group.
with age_segment as(select *,
   (case  
   when customer_age<= 25 then '18-25'
   when customer_age<= 35 then '26-35'
   when customer_age <= 50 then '36-50'
   else
   'above 50'
   end) as age_group
from customer_churn
)
  select distinct age_group,count( distinct customer_id )as total,
  round(count( distinct customer_id )filter(where churn =1) / count( distinct customer_id )::numeric *100,2) as churn_rate
  from age_segment
  group by 1
  order by round(count( distinct customer_id )filter(where churn =1) / count( distinct customer_id )::numeric *100,2)desc;

--4. High value customers that have churned.
  --Top 10 high value customers that were churned.
select distinct customer_id,customer_name,
       sum(quantity* product_price) as total_spent
	   from customer_churn
        where churn =1
	   group by  distinct customer_id,customer_name
	   order by sum(quantity* product_price) desc
	   limit 10;

--5. Gender wise churn-rate.
  
with gender_group as(
select distinct customer_id, gender, churn
from customer_churn
)
select gender,
   round(sum(case when churn =1 then 1 else 0 end) /count(customer_id)::numeric * 100,2) as rate
   from gender_group
   group by 1;
	   
--Cohort analysis over year.
with first_order as(select  distinct  customer_id,
                         date_trunc('year',min(purchase_date)) as cohort_month
	   from customer_churn
	   group by 1
	   ),
	   
purchases as(select distinct customer_id,
                    date_trunc('year' ,purchase_date) as buy_month
					from customer_churn
					)
select f.cohort_month, p. buy_month,
       count(distinct p.customer_id) as customers
from first_order f
join purchases p
on f.customer_id = p.customer_id
group by 1,2
order by 1,2;

--6. Monthly churned for each year/ churn trend
with n_churn as(
  select *,
  date_trunc('month',purchase_date) as per_month,
  extract ('year' from purchase_date) as year
  from customer_churn
  )
select  extract('month' from per_month) as n_month,
      to_char(per_month,'Mon') as months,
      count(distinct case when year = 2020 then customer_id else null end) as churn_in_2020, 
      count(distinct case when year = 2021 then customer_id else null end) as churn_in_2021,
	  count(distinct case when year = 2022 then customer_id else null end) as churn_in_2022,
	  case when count(distinct case when year = 2023 then customer_id  end)=0 then null
	       else count(distinct case when year = 2023 then customer_id  end)
           end as churn_in_2023
	  from n_churn
	  where churn= 1
	   group by 1,2
	   order by 1;
	   

--6. Quarterly Cohort Analysis .
  -- Counting new customers for each quarter and see how many of then repurchase after 3 months.
with customer_cohort as(
      select customer_id,
      date_trunc ('quarter',min(purchase_date)) as cohort
      from customer_churn
      group by customer_id
      ),
monthly_buy as(
       select cu.customer_id,
	   ch.cohort,
       (cu.purchase_date::date - ch.cohort::date)/90 as n_quarter
       from customer_churn cu
       left join customer_cohort ch
       on cu.customer_id= ch.customer_id
	   )
select to_char(cohort::date,'Mon yyyy'),
count(distinct customer_id)filter(where n_quarter=0) as first_q,
count(distinct customer_id)filter(where n_quarter=1) as second_q,
count(distinct customer_id)filter(where n_quarter=2) as third_q,
count(distinct customer_id)filter(where n_quarter=3) as fourth_q
from monthly_buy
group by cohort;









