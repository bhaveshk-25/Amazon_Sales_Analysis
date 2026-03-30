# Amazon Sales Analysis

## Project Overview

This project analyzes Amazon-style sales data to uncover business trends, customer behavior, and product performance. The goal is to provide actionable insights for revenue growth, customer retention, and product optimization.

---

## Business Objectives

- **Understand revenue trends**: Identify overall and seasonal revenue patterns.
- **Analyze customer behavior**: Segment customers, measure retention, and calculate customer lifetime value (CLV).
- **Evaluate product performance**: Find top/bottom products and category-wise revenue.
- **Support business decisions**: Enable data-driven strategies for marketing, inventory, and sales.

---

## Project Workflow

1. **Data Collection & Schema Design**
	 - Data includes sales, products, customers, stores, and calendar tables.
	 - Schema is defined in `Schema.sql` and data is stored in CSV files under `Dataset/`.

2. **Data Cleaning & Preparation**
	 - Performed in `EDA.ipynb` using pandas.
	 - Handles missing values, product ID corrections, and exports cleaned data.

3. **Exploratory Data Analysis (EDA)**
	 - Initial data exploration and validation.
	 - Checks for anomalies and prepares data for SQL analysis.

4. **SQL Analysis**
	 - Core business queries in `Queries.sql`:
		 - Revenue, order volume, average order value.
		 - Product/category performance.
		 - Customer segmentation and CLV.
		 - Time series trends (monthly, weekday/weekend, running totals).

5. **Insights & Reporting**
	 - Each query includes business insights as comments.
	 - Results guide recommendations for business strategy.

---

## Key Insights

- **Revenue & Orders**
	- Total revenue: ~$25.5M; ~100,000 orders.
	- Average order value: ~$25.5.
	- Monthly revenue is stable, with peaks during festival/promotional periods.

- **Product Performance**
	- Top 2 products contribute disproportionately to revenue (Pareto principle).
	- Praline, White, and Dark categories lead in revenue.
	- No products with zero sales, indicating a healthy catalog.

- **Customer Analysis**
	- Top customers spend similarly, forming a valuable segment.
	- No one-time buyers; strong retention or limited data window.
	- High CLV customers should be targeted for retention and upselling.
	- Customers inactive for 3+ months are potential churn risks.

- **Time Series Trends**
	- Revenue shows seasonality and steady growth.
	- Weekdays generate more revenue than weekends.
	- Running revenue total grows linearly, aiding forecasting.

---

## File Structure

- `Schema.sql`: Database schema for all tables.
- `Dataset/`: Raw CSV data for calendar, customers, products, sales, and stores.
- `EDA.ipynb`: Data cleaning and initial exploration.
- `Queries.sql`: SQL queries and business logic.
- `README.md`: Project documentation.

## Project status : Ongoing

---

## Conclusion

---
