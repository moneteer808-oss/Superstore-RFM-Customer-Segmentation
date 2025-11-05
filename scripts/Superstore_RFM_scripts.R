library(tidyverse)
library(janitor)
library(here)
library(lubridate)
library(DT)
library(htmltools)

# 1. Load data ----

data_path <- here("data", "superstore.csv")
superstore <- read_csv(data_path, show_col_types = FALSE) %>% clean_names()

# 2. Clean data ----

df <- superstore %>%
  mutate(order_date = as.Date(order_date, tryFormats = c("%Y-%m-%d", "%m/%d/%Y"))) %>%
  filter(!is.na(customer_id), !is.na(order_date), !is.na(sales))

# 3. Compute RFM ----

analysis_date <- max(df$order_date, na.rm = TRUE) + 1
rfm_data <- df %>%
  group_by(customer_id, customer_name) %>%
  summarise(
    recency_days = as.integer(analysis_date - max(order_date)),
    frequency = n_distinct(order_id),
    monetary = sum(sales, na.rm = TRUE),
    .groups = "drop"
  )
head(rfm_data)

# Fix character encoding to avoid DT::datatable() errors
rfm_data <- rfm_data %>%
  mutate(across(where(is.character), ~ iconv(.x, from = "latin1", to = "UTF-8", sub = "byte")))

# 4. Assign RFM scores ----
rfm_data <- rfm_data %>%
  mutate(
    R_score = ntile(-recency_days, 5),  # smaller recency = higher score
    F_score = ntile(frequency, 5),
    M_score = ntile(monetary, 5),
    RFM_Score = R_score + F_score + M_score
  )
head(rfm_data)
names(rfm_data)

# 5. Customers segmentation ----

rfm_data <- rfm_data %>%
  mutate(
    Segment = case_when(
      RFM_Score >= 13 ~ "Champions",
      RFM_Score >= 10 ~ "Loyal Customers",
      RFM_Score >= 7  ~ "Potential Loyalists",
      RFM_Score >= 4  ~ "Needs Attention",
      TRUE ~ "At Risk"
    )
  )

# View segment count

table(rfm_data$Segment)

# 6. Summarize segments ----
segment_summary <- rfm_data %>%
  group_by(Segment) %>%
  summarise(
    Customers = n(),
    Avg_Recency = round(mean(recency_days), 1),
    Avg_Frequency = round(mean(frequency), 1),
    Avg_Monetary = round(mean(monetary), 2),
    .groups = "drop"
  )

segment_summary

# 7. Visualize RFM Segments ----
rfm_plot <- ggplot(segment_summary, aes(x = reorder(Segment, -Customers), y = Customers, fill = Segment)) +
  geom_col() +
  geom_text(aes(label = Customers), vjust = -0.5, size = 4) + # numbers above bars
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +   # add 10% space on top
  labs(
    title = "Customer Segments (RFM Analysis)",
    x = "Customer Segment",
    y = "Number of Customers"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

rfm_plot

# --- Scatter plot: Recency vs Monetary colored by Segment ---

# Create plot

rfm_scatter <- ggplot(rfm_data, aes(x = recency_days, y = monetary, color = Segment)) +
  geom_point(alpha = 0.7, size = 3) +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(
    title = "Customer Value Distribution: Recency vs. Monetary",
    subtitle = "Color represents customer segment classification",
    x = "Recency (Days Since Last Purchase)",
    y = "Total Spend (Monetary Value)",
    color = "Segment"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 15),
    legend.position = "bottom"
  )

# Display the plot in report

rfm_scatter
# --- Scatter plot: Recency vs Monetary colored by Segment ---

# Create plot

rfm_scatter <- ggplot(rfm_data, aes(x = recency_days, y = monetary, color = Segment)) +
geom_point(alpha = 0.7, size = 3) +
scale_y_continuous(labels = scales::dollar_format()) +
labs(
title = "Customer Value Distribution: Recency vs. Monetary",
subtitle = "Color represents customer segment classification",
x = "Recency (Days Since Last Purchase)",
y = "Total Spend (Monetary Value)",
color = "Segment"
) +
theme_minimal(base_size = 13) +
theme(
plot.title = element_text(face = "bold", size = 15),
legend.position = "bottom"
)

# Display the plot in report

rfm_scatter

# Save the plot into /figures folder

if (!dir.exists(here("figures"))) dir.create(here("figures"), recursive = TRUE)
ggsave(here("figures", "rfm_scatter_recency_monetary.png"), plot = rfm_scatter, width = 8, height = 6)



# 8. Save Outputs ----

# Ensure folders exist
if(!dir.exists(here("output"))) dir.create(here("output"), recursive = TRUE)
if(!dir.exists(here("figures"))) dir.create(here("figures"), recursive = TRUE)

# Save CSV files
write_csv(rfm_data, here("output", "rfm_scores.csv"))
write_csv(segment_summary, here("output", "rfm_segment_summary.csv"))
message("RFM results exported to /output folder")

# Save plot
ggsave(here("figures", "rfm_segment_plot.png"), plot = rfm_plot, width = 8, height = 5)
message("Plot saved to /figures folder")


# 9.1 Business insights ----
business_actions <- tibble(
  Segment = c("Champions", "Loyal Customers", "Potential Loyalists", "Needs Attention", "At Risk"),
  Description = c(
    "Recent, frequent, and high spenders",
    "Frequent and consistent buyers",
    "Medium RFM score, possible repeat buyers",
    "Low-medium RFM score, may churn",
    "Low in all RFM metrics"
  ),
  Suggested_Action = c(
    "Offer loyalty rewards, exclusive deals, VIP treatment",
    "Encourage reviews, referrals, upsell, cross-sell",
    "Engage with promotions, targeted campaigns",
    "Send reactivation campaigns, special offers",
    "Win-back campaigns, discounts, personalized outreach"
  )
)
business_actions

# 9.2 Compute overall stats from the existing rfm_data ----

segment_stats <- rfm_data %>%
  group_by(Segment) %>%
  summarise(
    Customers = n(),
    Avg_Recency = mean(recency_days),
    Avg_Frequency = mean(frequency),
    Avg_Monetary = mean(monetary),
    .groups = "drop"
  ) %>%
  arrange(desc(Avg_Monetary))


# Identify top-performing and at-risk segments

top_segment <- segment_stats$Segment[1]
lowest_segment <- segment_stats$Segment[nrow(segment_stats)]


# Scatter plot: Recency vs Monetary colored by Segment

ggplot(rfm_data, aes(x = recency_days, y = monetary, color = Segment)) +
  geom_point(alpha = 0.7, size = 3) +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(
    title = "Customer Value Distribution: Recency vs. Monetary",
    subtitle = "Color represents customer segment classification",
    x = "Recency (Days Since Last Purchase)",
    y = "Total Spend (Monetary Value)",
    color = "Segment"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 15),
    legend.position = "bottom"
  )
# Save the plot into /figures folder


# 10. Customer by segments ----

# Save full customers segmentation details to .csv

write_csv(rfm_data, here("output", "rfm_customer_segments.csv"))
message("Customer segmentation details exported to /output folder")

# Showing customers interactive table by segment


datatable(
  rfm_data %>%
    select(customer_id, customer_name, Segment, recency_days, frequency, monetary, RFM_Score) %>%
    arrange(desc(RFM_Score)),
  options = list(pageLength = 10, autoWidth = TRUE),
  caption = htmltools::HTML("<b>Interactive Table: Customer Segmentation Details</b>"),
  escape = FALSE
)

# 11. Session info ----
sessionInfo()

