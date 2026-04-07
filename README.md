# Amazon Chocolate Sales Analysis

## Project Background

This project analyzes sales data for a chocolate retail business operating on Amazon, covering the period **2023–2024**. The company sells a diverse catalog of chocolate products across multiple categories — including Dark, Milk, White, Praline, and Truffle — distributed through various store types globally.

As a data analyst working with this business, the goal is to uncover revenue trends, evaluate product performance, understand customer behavior, and identify actionable growth opportunities.

Insights and recommendations are provided on the following key areas:

- **Product Performance:** Revenue contribution by product and category, identification of top and bottom performers
- **Customer Behavior:** Repeat vs. new customer breakdown, customer lifetime value (CLV), and churn risk
- **Time Series Trends:** Monthly revenue patterns, seasonality, weekday vs. weekend sales, and running totals
- **Business Metrics:** Overall revenue, order volume, and average order value (AOV)

The SQL queries used to inspect and clean the data for this analysis can be found [here](./Queries.sql).

---

## Data Structure & Initial Checks

The database consists of five tables with a total of **100,000 order records**. A description of each table is as follows:

- **sales:** The central fact table containing `order_id`, `order_date`, `product_id`, `store_id`, `customer_id`, `quantity`, `unit_price`, `discount`, `revenue`, `cost`, and `profit`
- **customer_dim:** Customer dimension with `customer_id`, `age`, `gender`, `loyalty_m` (loyalty membership), and `join_date`
- **product_dim:** Product dimension with `product_id`, `product_name`, `brand`, `category`, `cocoa_per` (cocoa percentage), and `weight_g`
- **store_dim:** Store dimension with `store_id`, `store_name`, `city`, `country`, and `store_type`
- **date_dim:** Date dimension with `date`, `year`, `month`, `day`, `week`, and `day_of_week`

![Entity Relationship Diagram](./Database.png)

---

## Executive Summary

### Overview of Findings

The business generated **$25.5M in total revenue** across 100,000 orders during 2023–2024, with a steady average order value of $25.5. Praline emerged as the dominant product category at ~$6.5M in revenue, while monthly performance remained consistent at ~$1M per month, with mid-year spikes suggesting seasonal demand patterns. Customer retention appears strong — all recorded customers made repeat purchases — though a segment of inactive customers presents a re-engagement opportunity.

---

## Insights Deep Dive

### Product Performance

- **Praline leads all categories with ~$6.5M in revenue**, followed closely by White (~$6M) and Dark (~$5.5M). Truffle (~$4M) and Milk (~$3.5M) are significantly behind, suggesting potential for repositioning or promotional investment in these categories.

- **Top 2 products account for a disproportionate share of revenue (~$250K each)**, with White Chocolate 80% and Milk Chocolate 50% leading. This Pareto-like distribution indicates heavy reliance on a small number of SKUs.

- **Higher cocoa percentage products (80%, 90%) dominate the top 10 revenue list**, suggesting that premium or specialty variants resonate strongly with buyers and could be candidates for further product line expansion.

- **Bottom 10 products are tightly clustered in revenue (~$120K–$125K)**, with multiple Praline variants (70%, 80%, 90%) underperforming. Low variance in this group suggests they have similar but limited demand — a signal to revisit pricing, positioning, or possible discontinuation.

- **All products have at least one sale**, indicating a well-curated catalog with no completely dead SKUs.

---

### Customer Behavior

- **All customers are repeat buyers** — no one-time purchasers were found in the dataset. This points to either strong retention or a limited observation window. Further cohort analysis would help clarify true churn patterns.

- **Top 10 customers by spend are tightly grouped (~$1,095–$1,183 in total spending)**, suggesting a homogeneous high-value segment. These customers are strong candidates for personalized loyalty rewards or early access programs.

- **CLV analysis identifies high-value customers** who drive the most long-term revenue on a per-year basis. These accounts should be prioritized for retention and upselling strategies.

- **Customers inactive for 3+ months** (last order before October 2024) represent a churn risk pool. These individuals can be targeted with re-engagement campaigns such as personalized discounts or product recommendations.

---

### Time Series Trends

- **Monthly revenue is stable at ~$1M**, with notable peaks in mid-2023 and mid-2024 likely tied to seasonal events or promotional campaigns. Post-peak troughs suggest a need for off-season demand stimulation.

- **Weekdays generate significantly more revenue than weekends**, indicating that purchasing behavior is driven by routine or business-related buying rather than leisure browsing. Marketing campaigns and promotions may have stronger ROI on weekdays.

- **The running revenue total crossed $22M by September 2024**, growing almost linearly — a sign of consistent sales without significant disruptions or revenue gaps.

- **Overall trajectory indicates steady growth**, confirming that demand capture strategies are working effectively during high-traffic retail months.

---

### Business Metrics

- **Total Revenue: $25,486,129** — reflecting a healthy business scale over the two-year period.
- **Total Orders: 100,000** — a clean, round figure suggestive of a well-sampled or synthetic dataset; worth validating against operational records.
- **Average Order Value (AOV): $25.5** — a relatively low AOV that suggests opportunities for bundling, upselling, or minimum-order incentives to increase basket size.

---

## Recommendations

Based on the insights and findings above, we would recommend the product and marketing teams to consider the following:

- **Praline, White, and Dark chocolate are the top revenue drivers.** Double down on inventory, promotions, and product expansion within these categories to sustain and grow their lead.

- **Top-2 products (White Chocolate 80%, Milk Chocolate 50%) drive disproportionate revenue.** Ensure consistent stock availability and explore co-marketing or bundle opportunities around these SKUs.

- **Bottom-10 products show low, uniform revenue.** Conduct a profitability review to determine whether underperformers should be repositioned, discounted to clear stock, or phased out.

- **All customers are repeat buyers, forming a strong retention base.** Introduce a formal CLV-based segmentation strategy to tier customers and tailor engagement — prioritize top CLV customers for retention spend.

- **Customers inactive for 3+ months are at churn risk.** Launch targeted re-engagement campaigns (email, personalized discount codes) before they lapse entirely. Use last purchase date as a trigger.

- **AOV at $25.5 is relatively low.** Introduce bundle deals, minimum spend thresholds for free shipping, or "frequently bought together" recommendations to increase basket size per transaction.

- **Weekday revenue dominates.** Concentrate ad spend, flash sales, and campaign launches on weekdays for maximum impact; explore weekend-specific promotions to smooth the revenue curve.

---

## Assumptions and Caveats

Throughout the analysis, multiple assumptions were made to manage challenges with the data. These are noted below:

- The analysis uses `DATE '2025-01-01'` as a reference point for churn detection (instead of `CURRENT_DATE`) since the dataset covers 2023–2024 and using today's date would have flagged all customers as inactive.
- All customers in the dataset are classified as repeat buyers. This may reflect a limited observation window rather than true 100% retention — further cohort analysis with acquisition dates is recommended to validate.
- Revenue figures are assumed to already account for discounts applied at the transaction level. The `revenue` column is used as the primary metric throughout.
- The 100,000 order count is a round number; it is unclear whether this represents the complete transaction history or a sampled extract. Results should be interpreted accordingly.
