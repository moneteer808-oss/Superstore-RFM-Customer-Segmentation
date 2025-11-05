# RFM Customer Segmentation Analysis

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![RMarkdown](https://img.shields.io/badge/RMarkdown-75AADB?style=for-the-badge&logo=r&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

A customer segmentation project using RFM (Recency, Frequency, Monetary) analysis to identify high-value customers and create targeted marketing strategies for a retail Superstore.

> **[View Live Report](https://https://superstorerfmdemo79c818.netlify.app)** | **[See Project 2: Predictive Customer Analytics](https://moneteer808-oss.github.io/Superstore-Predictive-Customer-Analytics/)**

---

## What is RFM Analysis?

RFM segments customers based on three behavioral metrics:
- **Recency:** How recently did they purchase?
- **Frequency:** How often do they buy?
- **Monetary:** How much do they spend?

**Result:** 5 actionable customer segments from Champions to At Risk.

---

## Key Features

**Automated RFM scoring** for all customers  
**5 customer segments** with tailored strategies  
**Interactive HTML report** with visualizations  
**Exportable datasets** for CRM integration  
**Business recommendations** for each segment  

---

## Quick Start

### 1. Install Dependencies
```r
install.packages(c("tidyverse", "janitor", "lubridate", "here", 
                   "knitr", "ggplot2", "DT", "glue"))
```

### 2. Clone & Prepare Data
```bash
git clone https://github.com/moneteer808-oss/Superstore-RFM-Customer-Segmentation.git
cd Superstore-RFM-Customer-Segmentation
```

Download [Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final/data) → place in `data/` folder

### 3. Generate Report
```r
rmarkdown::render("Superstore_RFM_Customer_Segmentation.Rmd")
```

**Output:** Professional HTML report in your report project folder

---

## Results

| Segment | Customers | Avg Spend | Priority Action |
|---------|-----------|-----------|-----------------|
| **Champions** | 121 | $4,523 | VIP rewards, exclusive access |
| **Loyal Customers** | 256 | $2,856 | Upsell, cross-sell campaigns |
| **Potential Loyalists** | 218 | $1,646 | Engagement promotions |
| **Needs Attention** | 159 | $892 | Reactivation emails |
| **At Risk** | 39 | $423 | Win-back campaigns (urgent) |

**Key Insight:** Top 32% of customers drive 65% of revenue.
<img width="2400" height="1500" alt="rfm_segment_plot" src="https://github.com/user-attachments/assets/620e45d0-2ccb-4d1b-af18-1c5bb98e8bb5" />

<img width="2400" height="1800" alt="rfm_scatter_recency_monetary" src="https://github.com/user-attachments/assets/60210e28-5058-4259-a2c0-8b8d9a98822d" />

**Interpretation:** Customers toward the left (low recency) and high on the y-axis (high spenders) are your Champions — frequent, recent, and high-value buyers.
Those farther to the right show longer inactivity periods and lower spend, representing At Risk segments.

---

## Project Structure

```
Superstore-RFM-Customer-Segmentation/
└── Superstore-RFM-Customer-Segmentation.Rproj      # R project
├── data/
│   └── Superstore.csv                              # Raw data
├── output/
│   ├── rfm_scores.csv                              # Customer metrics
│   ├── rfm_segment_summary.csv                     # Segment stats
│   └── rfm_customer_segments.csv                   # Segment assignments
├── figures/
│   └── rfm_segment_plot.png                        # Visualization
│   ├── rfm_scatter_recency_monetary.png            # Scatter plot visualization
├── reports/
│   ├── Superstore_RFM_Customer_Segmentation.Rmd    # Analysis report
│   └── Superstore_RFM_Customer_Segmentation.html   # Knitted HTML output
└── scripts/
    └── Superstore_RFM_scripts.R                    # R script
```

---

## Business Value

This analysis enables:
- **Targeted marketing** by segment behavior
- **Optimized budget** allocation to high-ROI customers
- **Proactive churn prevention** for at-risk segments
- **Data-driven decisions** replacing gut feeling
- **Repeatable process** for ongoing monitoring

---

## What's Next?

### Project 2: Predictive Customer Analytics

** [View Repository](https://github.com/moneteer808-oss/Superstore-Predictive-Customer-Analytics)** | ** [Live Report](https://moneteer808-oss.github.io/Superstore-Predictive-Customer-Analytics/)**

Building on this RFM foundation, Project 2 adds **machine learning**:

- **CLV Prediction:** Forecast future customer value with XGBoost
- **Churn Forecasting:** Identify at-risk customers proactively  
- **Advanced Segmentation:** 9-segment matrix (Value × Retention)
- **ROI Analysis:** Calculate campaign cost-benefit by segment
- **Priority Lists:** Auto-generate high-value, at-risk customer lists

**RFM tells you WHO your customers are → ML tells you what they'll DO NEXT**

---

## Technologies

- **R 4.3+** | **RMarkdown** | **tidyverse** | **ggplot2** | **DT** (interactive tables)

---

## License

Educational use only. Dataset © original creators.

---

## 📧 Contact

**Moneteer** | [GitHub Profile](https://github.com/moneteer808-oss)

**Live Reports:**  
- [Part 1: Interactive RFM Segmentation](https://superstorerfmdemo79c818.netlify.app)
- [Part 2: Predictive Customer Analytics](https://moneteer808-oss.github.io/Superstore-Predictive-Customer-Analytics/)

---

**Star this repo** if you found it useful!  
**Check out Part 2** for the machine learning continuation!

**Exploring data and technology through self-learning - Moneteer**
