# SQL_Target_Business_Analysis
Analysis on data of 100,000 business operations 
INSIGHTS: 
Analysed the nature of data using dataset. INFORMATION_SCHEMA.COLUMNS, typeof(column_name) function.
From this data we can understand in the initial year of 2016 the no of orders was only 329 as it just started but later on the number of orders grew massively and they have always been high on the months of October to March by the analysis.
According to month wise analysis, the number of orders has always been high on the months of October to March each year after 2017 (Ignoring the year 2016 since it was the starting year).
Analysis showed that the highest number of orders were placed during afternoon time.
The count of 38,135 orders being the highest, was placed during the afternoon time. 
Analyzed orders based on states, and did monthly analysis on how many orders have been placed from that state on that particular month.
Here we get the analysis of how many customers belong to each state in the country of Brazil, and it is ordered by the count of customers in each state, the highest number of customers are from PI and the least from RR.
Analyzed the prices understood that the prices have gone up from the year 2017, to 1.3x times in the year 2018.
Calculated the total sum of order price for each order id and the average order price for order id and then group by each state producing final total and average.
Calculated the total sum of order freight value for each order id and the average order freight value for order id and then group by each state producing final total and average.
Understood the number of days each order took to be delivered which is around 12 days and the difference between the estimated delivery date and the actual delivery date, for many orders the delivery has been earlier than expected, but for 6535 records the delivery has been delayed by some days which can adhere to a loss for the company.
Identified that the 5 states SP, PR, MG, RJ, DF are having the lowest avg_frieght_value and the 5 states PI, AC, RO, PB, RR are having the highest avg_frieght_value.
Analyzed the difference between the estimated delivery date and the actual delivery date.
Identified AC, AM, RO, AP, RR as the top 5 states that deliver prior to the actual delivery date.
Understood the no. of orders placed on the basis of the payment instalments that have been paid.
