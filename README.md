## SQL Exploratory Data Analysis (EDA): Sales & Customer Insights

## Project Overview
This project focuses on **Exploratory Data Analysis (EDA)** using a retail dataset extracted from a **Gold Layer** Data Warehouse. The goal is to uncover business trends, analyze customer behavior, and evaluate product performance to support data-driven decision-making.

**Data Architecture:** Medallion Architecture (Bronze -> Silver -> Gold).
**Tools Used:** MySQL, TablePlus, GitHub.

---

## Project Structure
- `/datasets`: Contains sample data (CSV) extracted from the Gold Layer.
- `/scripts`: SQL scripts for EDA (Descriptive statistics, Running Totals, Lifespan analysis, etc.).
- `/docs`: Data Dictionary and summary reports of findings.

---

## Key Business Questions
1. **Revenue Trends:** Monthly revenue growth and Cumulative Sales (Running Total).
2. **Product Performance:** Top 5 best-selling products and Average Selling Price (ASP) analysis.
3. **Customer Analytics:** Calculating Customer Lifespan and New Customer Acquisition by year.
4. **Data Quality:** Identifying and handling NULL values or Outliers during the EDA process.

---

## Key Insights
- **Seasonality:** Revenue peaked in [Month/Year] likely due to [Hypothetical reason, e.g., Year-end Sale].
- **Customer Loyalty:** High-lifespan customers contribute to [X]% of total revenue, suggesting a need for a loyalty program.
- **Data Integrity:** Identified [X]% missing product keys in the Silver layer, which were resolved by [Your Method].

---

## How to Use
1. Import the CSV files from the `/datasets` folder into your MySQL environment.
2. Execute the SQL scripts in the `/scripts` folder in sequential order.
3. Review the `/docs` folder for detailed column definitions.
