# E -commerce customer churn analysis

## Overview
#### The project analyze customer churn data using SQL, Excel and Power BI. Each row shows unique purchases/orders with order date. The project analyze churned customers age, gender, purchase amount and quantity and cohort analysis.

## Dataset Overview
- Purchase date
- Product price
- Quantity
- Product category
- Churn : 0/1
- Return
- Customer name
- Customer ID
- Customer age
- Gender

## Tools
### PostgreSQL
- Cohort Analysis : How many customers return to buy again after their first purchase in every quarter
- Customer at risk list : Customers who are most likely to churn by analyzing their orders frequecy and spending over time.

### Excel
- Data cleaning : trim whitespace, standerdizing text, Null handeling

### Power BI
- Created a star shema and build relationship
 - Created Dashboard using charts and cards
  - Created New colums and mesurment using DAX
  - Line chart : monthly churn customers
  - Bar Chart : Churn rate for each age group type
  - Cards : Churn rate, Total customers, Expected revenue loss due to churn
  - Slicer
  
## Insights
 **1.KPI :**
 - Customer churn in four year : 20%
 - Total customers : 49.6K
 - Expected revenue loss due to churn : 38M
 - Return rate : 40%  *High return rate affect the net revenue as well business. No data available about return reason*
 
 **2.Churn trend:** Number of churn customer is high for April, June and September in each year.
 
 **3.Customer churn rate by age :** Segmented customer age who have churned and found that customers between 18 - 25 have churned more than 20%
 
 **4.Customer churn rate by gender :** Male 20.30%, Female 19.73%
 
## Recommendation :
 - Run ads with discount for those month when number of churn customers is high.
 - Target customers age between 18 to 25 with discount price.
 - Return rate is 40%, analyze the reason, delivery time, product quality, customer satisfaction data.
 - Create special offers for high value customers.
 
 
 
  


