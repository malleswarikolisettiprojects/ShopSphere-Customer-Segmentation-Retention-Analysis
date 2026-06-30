# ShopSphere Customer Segmentation & Retention Analysis

## Project Overview
  ShopSphere is a growing boutique e-commerce brand that experienced a 15% decline in repeat purchase rates over the last quarter. The marketing team currently sends the same generic email campaign to all customers, resulting in low customer engagement and reduced marketing effectiveness. In this project, I analyzed customer purchasing behavior by calculating key business metrics such as Average Order Value (AOV), Customer Lifetime Value (CLV), Churn Rate, and Repeat Purchase Rate. I also performed RFM Analysis using K-Means Clustering, conducted Correlation Analysis, and built a Logistic Regression model to predict each customer's Churn Risk Score, helping the business identify high-risk customers and improve targeted marketing strategies.

## Problem Statement
  The objective of this project is to improve marketing return on investment (ROI) by replacing generic marketing campaigns with data-driven customer segmentation and predictive churn identification. Currently, ShopSphere sends the same promotional emails to every customer regardless of their purchasing behavior, resulting in low engagement. This approach has contributed to a 15% decline in repeat purchase rates, making it difficult to retain valuable customers and optimize marketing efforts.

## Dataset
**Source :** Kaggle – Brazilian E-Commerce Public Dataset by Olist

**Time Period :** 2016–2018

**Dataset Size :** Approximately 100,000 records

**Tables Used :**
- Customers
- Orders
- Order_Items
- Products

## Tools & Technologies
**Tools :**
- MySQL Workbench
- Power BI
- Visual Studio Code

**Technologies :**
- SQL
- Python
- Pandas
- Numpy
- Scikit-Learn
- Matplotlib
- Seaborn
- Machine Learning : K-Means , Logistic Regression

## Project Workflow
**Step - 1 :** Downloaded the Brazilian Olist E-Commerce dataset from Kaggle.

**Step - 2 :** Created the ShopSphere database.

**Step - 3 :** Imported CSV files into MySQL.

**Step - 4 :** Performed data validation.

**Step - 5 :** Performed SQL business analysis like AOV,CLV.

**Step - 6 :** Created SQL Views LIKE vw_customer_order,
vw_revenue_by_category.
vw_aov_city,
vw_aov_state.

**Step - 7 :** Built the master_analysis_dataset

**Step - 8 :** Imported the master dataset into Python and Performed EDA, Missing value verification.

**Step - 9 :** Performed RFM Analysis.

**Step - 10 :** Standardized RFM variables using StandardScaler.

**Step - 11 :** Applied K-Means clustering by using the Elbow Method and Assigned customer segments.

**Step - 12 :** Performed correlation analysis.
     
**Step - 13 :** Built the Logistic Regression model to generate Churn Risk Score,  Risk Categories 

**Step - 14 :** Exported results as CSV files

**Step - 15 :** Created Power BI dashboards with Interactive reports, Marketing insights.

## SQL Analysis
**Revenue by Category :**
- Joined Orders, Order_Items, and Products to calculate total revenue by product category.
- Considered only delivered orders and used the results to identify the highest-performing product categories.

**Customer Recency :**
- Calculated each customer's last purchase date.
- Computed recency in days and Stored the results in a temporary table.

**Average Order Value (AOV) :**
- Calculated AOV by city and state.
- Compared geographic spending patterns and identified regions with higher customer spending.

**Monthly Revenue Trend :**
- Compared monthly revenue.
- Calculated month-over-month percentage change using LAG().
- Used it to validate the reported decline in repeat purchases.

**Repeat Purchase Rate :**
- Identified repeat customers.
- Calculated the repeat purchase percentage.

**Customer Lifetime Value (CLV) :**
- Aggregated total customer spending.
- Ranked customers based on lifetime value by using DENSE_RANK() and identified high-value customers

**Views :** 
- **vw_customer_order :** Joined Customers, orders, order_items to get customer details, order details and the product prices.

- **vw_customer_recency :** View on Repeat Purchase Rate.

- **vw_aov_city :** View on Average Order Value by City.

- **vw_aov_state :** View on Average Order Value by State.

- **view for revenue by category :** View on Revenue by Category


## Python Analysis
**Data Preparation :**
- Imported the master_analysis_dataset.
- Inspected the data and verified data types.
- Checked missing values.
- Prepared the data for analysis.

**RFM Analysis :**
- Created customer-level Recency, Frequency, and Monetary metrics.
- Aggregated the data by customer_unique_id.
- Converted recency into days and built the rfm_table

**Standardization :**
- Standardized numerical features using StandardScaler.
- Ensured variables with different scales contributed equally during clustering.

**Customer Segmentation :**
- Used the Elbow Method to determine an appropriate number of clusters.
- Applied K-Means clustering.
- Assigned business-friendly labels (such as New, At Risk, High Value, Champions) based on cluster characteristics.

**Correlation Analysis :**
- Investigated relationships between: Freight Value, Shipping Time, Churn using Heatmap
- Used visualizations like Scatter Plot and Box Plot to identify patterns and potential outliers.

**Data Export :**
- Exported the processed datasets and used them as inputs for Power BI dashboards.

## Machine Learning
**Objective :** To predict which customers are likely to churn so the marketing team can take proactive retention actions.

**Model Selection :** Logistic Regression is choosen as a model as it is suitable for binary classification (churn vs non-churn).

**Feature Selection :** The Features that are used for prediction are : Recency, Frequency, Monetary, Freight Value, Shipping Time.

**Target Variable :** churn was the target variable as
it represents whether a customer had churned or not.

**Data Preparation :** Split the data into training and testing sets and Standardize the features before training.

**Model Training :** Trained the Logistic Regression model and predicted customer churn.

**Model Evaluation :** To evaluate the Model predictions the evaluation metrics used are : Accuracy, Precision, Recall, F1 Score, Confusion Matrix and Classification Report.

**Churn Risk Score :** The model generated a probability between 0 and 1 for each customer, representing their likelihood of churning.
The Customers are categorized into : Low Risk, Medium Risk, High Risk based on Probability
(Low Risk => probability < 0.3 , 
Medium Risk => probability < 0.7
otherwise High Risk).

## Power BI Dashboard
**1. Overview Dashboard :** This page gives the information about Revenue or Sales. 
- Used cards to show KPI's like Total Revenue, Total Orders, Total Customers, Active Customers, Customer Lifetime Value(CLV).
- Used Donut Chart to visualize Revenue by Customer Segmentation.
- Used Line Chart to Visualize Monthly Sales Growth vs Churn Rate
- Used Map to visualize Sales density by Brazilian States.
- Created slicers like Customer Segmentation, Purchase Date and Customer State to make Dashboard more interactive.

**2. Customer and Product Analysis Dashboard :** This page helps marketing teams understand different customer groups.
- Used Clustered Bar chart to visualize Customer Segmentation Distribution.
- Used Clustered Bar chart and filter to visualize Top 10 High Revenue Product Categories.
- Used Clustered Column Chart to Visualize RFM Analysis by Segment.
- Created Slicers like Product Categories, Customer Segmentation, and Customer State to make Dashboard more interactive.

**3.Churn Analysis :** This dashboard focuses on customer retention.
- Created a Card for KPI of High Risk Customers.
- created a table with customer_unique_id,cluster,
risk category, churn_risk_score, monetary, recency to get information about risk of churn.
- Used Clustered Bar chart to visualize Risk Category vs Customer count
- Used Scatter chart to visualize Frieght Value vs Churn Risk Score.
- Created slicers like risk category and cluster to make Dashboard more interactive.

## Results & Key Findings
- The **New** customer segment contained the highest number of customers and generated the largest share of revenue.
- The **Champions** segment showed the highest purchase frequency and represented the most loyal customers.
- Customers with higher recency values (customers who had not purchased recently) were significantly more likely to churn.
- Freight cost, shipping time, recency, frequency, and monetary value were identified as the most influential factors related to customer churn.
- Customers who placed only one order and had long periods of inactivity showed the highest churn probability.
- The Logistic Regression model successfully generated a Churn Risk Score (0–1) for every customer, enabling customer prioritization for retention campaigns with Accuracy : 0.99, 
Precision: 0.99, 
Recall   : 0.99,
F1 Score : 0.99.
- The interactive Power BI dashboard allows business users to monitor customer behavior, identify high-value customers, and target high-risk customers with personalized marketing strategies.

## Business Recommendations
Based on my analysis, I suggest the following recommendations:

1. Send special offers or reminder emails to customers who are at high risk of churning to encourage them to make another purchase.

2. Give rewards, discounts, or loyalty points to Champions and High Value customers to keep them engaged.

3. Send different marketing emails to different customer segments instead of sending the same email to everyone.

4. Try to reduce shipping time and freight charges because they may affect customer satisfaction and increase churn.

## How to Run

1. Clone this repository.
2. Download the Brazilian E-Commerce Public Dataset by Olist from Kaggle.
3. Import the CSV files into MySQL.
4. Execute the SQL scripts to create tables, clean data, and generate the `master_analysis_dataset`.
5. Export the dataset to CSV.
6. Open the Python notebook and run all cells to perform RFM analysis, clustering, correlation analysis, and churn prediction.
7. Open the Power BI dashboard and connect it to the exported CSV files.
8. Refresh the dashboard to view the latest insights.

## Conclusion

Working on this project helped me apply the concepts I learned in SQL, Python, Machine Learning, and Power BI to a real business problem. I learned how to prepare data, analyze customer behavior, build a churn prediction model, and create dashboards to present the results.