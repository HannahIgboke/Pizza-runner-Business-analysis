# Pizza:pizza:-runner-Business-analysis


![pizza_runner](Images/pizza_runner.png)

## Table of contents

- [Introduction](https://github.com/HannahIgboke/Pizza-runner-Business-analysis#introduction)
- Problem statement
- Skills demonstrated
- Data wrangling
  - Data collection and database creation
  - Exploratory data analysis
  - Data cleaning
- Data analysis
  - Pizza metrics
  - Runner and customer experience
  - Ingredient optimization
  - Pricing and ratings
  - Other required datasets
- Conclusion and Limitations

## Introduction

Danny was browsing Instagram when he saw an ad for 80s retro styling and pizza. He loved the idea, but he knew he needed to do more than just sell pizza to get seed funding for his new business. So, he decided to Uberize it and create Pizza Runner, a pizza delivery service.
Danny started by recruiting runners to deliver pizza from his house, which served as Pizza Runner Headquarters. He also maxed out his credit card to pay freelance developers to create a mobile app for customers to place orders. Pizza runner has come a long way and now needs to put its data collected into good use to better direct its runners and optimize operations.

P.S:This is challenge 2 — [Pizza runner](https://8weeksqlchallenge.com/case-study-2/) of the [8 Weeks SQL Challenge](https://8weeksqlchallenge.com/getting-started/) by Danny Ma.

## Problem statement
In order for pizza runner to better direct its runners and optimize operations, it requires insights and recommendations on the following focus areas:
- Pizza Metrics
- Runner and Customer Experience
- Ingredient Optimisation
- Pricing and Ratings

## Skills demonstrated

- Data wrangling in MySQL
- Power BI
- Project documentation


## Data wrangling

There are three processes in Data Wrangling: collection, exploratory data analysis, and cleaning. These steps are implored to make our data fit for analysis.

### Data collection and database creation
Owing to the fact that Danny had a few years of experience as a data scientist he knew that data collection was going to be critical for his business’ growth. He has provided a subset the Pizza runner data for the purpose of this analysis. 
I used MySQL Workbench to create a [database](SQL_files/Database_creation.sql) for Pizza runner and to carry out intensive analysis. Below is the Entity Relationship Diagram (ERD) showing the relationships between the tables in the database called pizza_runner.

![ERD](Images/ERD.png)

### Exploratory data analysis

It is best practice to perform Exploratory data analysis before cleaning to investigate the data, identify loopholes and further understand the relationship between tables.

On inspection, I observed some data quality issues in the customer_orders table, runer_orders table nincluding: inconsistencies in data types, and formatting.

customer_orders                                 |runner_orders                      
------------------------------------------------|---------------------------
![customer_orders](Images/customer_orders.PNG)  |![runner_orders](Images/runner_orders.PNG)   

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


runners                           |pizza_names                            |pizza_recipes                              |pizza_toppings  
----------------------------------|---------------------------------------|-------------------------------------------|-----------------------
![runners](Images/runners.PNG)    |![pizza_names](Images/pizza_names.PNG) |![pizza_recipes](Images/pizza_recipes.PNG) |![pizza_toppings](Images/pizza_toppings.PNG)   

  

### Data cleaning

The data preprocessing stage is specially reserved for cleaning the data and addressing every data quality issue observed in the EDA stage.
For the affected tables, the following issues were identified and treated:
-	customer_orders

Presence of blank cells in the exclusions and extras column and several occurences of ‘null’. I updated the column values from 'null' to NULL which means that in the extras columns mean that the value in a column is unknown or missing. 


-	runner_orders
  
1.	The pickup time column contains ‘null’ string entries instead of NULL and inappropriate data type
2.	The distance column contains ‘null’ string entries, and non-uniform entries such as ‘km’ and ‘ km’ or none and inappropriate data type
3.	The duration column is inconsistent. Some values have ‘mins’, ‘minutes’ , ‘minute’,  ‘null ‘or nothing and inappropriate data type
4.	The cancellation column contains ‘null’ entries



