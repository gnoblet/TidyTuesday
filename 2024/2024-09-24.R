tuesdata <- tidytuesdayR::tt_load('2024-09-24')

cty <- tuesdata$country_results_df
ind <- tuesdata$individual_results_df
time <- tuesdata$timeline_df

# Look at the variables
str(time)

library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
    library(patchwork)
library(gghighlight)
library(ggtext)
library(showtext)

#------ Data wrangling

#--- Plot 1

# Pivot longer all_contestant, male_contestant and female_contestant
time_longer <- time |> 
  pivot_longer(
    cols = c(male_contestant, female_contestant, all_contestant),
    names_to = "gender",
    values_to = "n"
  ) |> 
  # Remove "_contestant" from string in gender
  mutate(gender = str_remove(gender, "_contestant")) |> 
  select(year, country, countries, gender, n) |> 
  group_by(year, gender) |> 
  summarize(n = sum(n)) |> 
  filter(gender != "all") |> 
  ungroup()


#--- Plot 2

# Look at the share of Female contestants for the first top 10 countries
cty_gender_top_10 <- cty |>
  # Group by country
  group_by(country) |>
  summarize(tot = sum(team_size_all, na.rm = T), female = sum(team_size_female, na.rm = T)) |> 
  mutate(share = female/tot)

# Get the 3 countries with the lowest shares
cty_lowest_share <- cty_gender_top_10 |> 
  arrange(share) |>
  slice(1:3) |> 
  pull(country)

# Get the countries with the highgest shares
cty_highest_share <- cty_gender_top_10 |> 
  arrange(desc(share)) |>
  slice(1:3) |> 
  pull(country)

# Get countries which never had female contestants
cty_no_female <- cty_gender_top_10 |> 
  filter(female == 0) |> 
  pull(country) |> 
  length()


# Plot --- plots bind together

# Colors for gender
female_col <- "#5F4B8BFF"
male_col <- "#E69A8DFF"
# Colors for medals
gold <- "#D6AF36"
silver <- "#A7A7AD"
bronze <- "#824A02"

# Fonts
font_add_google("Roboto", "roboto")

# First plot: line plot
# x-axis: year
# y-axis:
# - color: gender
# - value: n
p1 <- ggplot(time_longer) + 
  # Labels: color legend is "Gender"
  # - female = Female
  # - male = Male
  geom_col(aes(x = year, y = n, color = gender, fill = gender), alpha = 0.6) +
  # Labels: color legend is "Gender"
  
  
  # Color
  # - female: #5F4B8BFF
  # - male: #E69A8DFF
  scale_color_manual(
    values = c(female_col, male_col),
    labels = c("Female", "Male")) +
  scale_fill_manual(
    values = c(female_col, male_col),
    labels = c("Female", "Male")) +
  # Labels
  labs(
    x = NULL,
    y = NULL,
    color = "Gender",
    fill = "Gender",
    title = "Number of <b><span style='color:#5F4B8BFF'>Female</span></b> and <span style='color:#E69A8DFF'><b>Male </b></span>Contestants"
  ) +
  # Add scale for ticks every 10 years
  scale_x_continuous(breaks = seq(1900, 2020, 10)) +
  # Theme
  theme_minimal(
    base_size = 14,
    base_family = "roboto"
  ) +
  theme(
    plot.margin = unit(c(30, 30, 30, 15), "pt"),
    plot.title = element_textbox_simple(size = 20),
    plot.title.position = "plot",
    axis.text = element_text(size = 14),
    legend.position = "none",
    legend.direction = "horizontal",
    plot.caption.position = "plot",
    text = element_text(
      family = "roboto",
      colour = "#4c4b4c"
   )
  )

# Third plot:
# Line plot
p2 <- ggplot(cty_gender_top_10) + 
  geom_point(
    aes(x = tot, y = female, size = share),
color = female_col,
  alpha = 0.6) +
  gghighlight(
    country %in% cty_highest_share, 
    label_key = country,
    label_params = list(size = 4.5, color = female_col),
   line_label_type = "ggrepel_text") +
  # Labels
  labs(
    size = "Share of Female Contestants",
    title = "<b><span style='color:#5F4B8BFF'>Female</span></b> Contestants Over <b>Total</b> Contestants by Country", 
    subtitle = "<br><span style='font-size: 16pt'>The United Arab Emirates, Oman, and Laos have the highest overall share of female contestants. </span>",
    color = "Country",
  ) +
  # Add scale for breaks every 50 total contestants
  scale_x_continuous(breaks = seq(0, 500, 50)) +
  # Add scale for breaks every 10 female contestants
  scale_y_continuous(
    breaks = seq(0, 100, 10)) +
    theme_minimal(
    base_size = 14,
    base_family = "roboto"
  ) +
  theme(
    plot.margin = unit(c(15, 0, 0, 15), "pt"),
    plot.title = element_textbox_simple(size = 20),
    plot.title.position = "plot",
    plot.subtitle = element_textbox_simple(size = 16),
    axis.title = element_blank(),
    axis.text = element_text(size = 14),
    legend.position = "bottom",
    legend.direction = "horizontal",
    text = element_text(
      family = "roboto",
      colour = "#4c4b4c"
  )
) 


# Bind all plots together
patchwork <- p1 / p2  + plot_annotation(
  title = "<b> A  gender glance at <span style='color:#D6AF36'>International </span><span style='color:#A7A7AD'>Mathematical</span><span style='color:#824A02'> Olympiads </b>",
  subtitle = "<br>The International Mathematical Olympiad (IMO) is the World Championship Mathematics Competition for High School students and is held annually in a different country. The first IMO was held in 1959 in Romania, with 7 countries participating. It has gradually expanded to over 100 countries from 5 continents. The competition consists of 6 problems and is held over two consecutive days with 3 problems each. </span>",
  caption = "Tidy Tuesday 2024-09-24 | Author: Guillaume Noblet",
  theme = theme(
    plot.title = element_textbox_simple(size = 24),
    plot.subtitle = element_textbox_simple(size = 16),
    plot.caption = element_text(size = 11),
    text = element_text(
      family = "roboto",
      colour = "#4c4b4c"
   )
  )
)
ggsave("2024/2024-09-24.png", plot = patchwork, width = 28, height = 30, units = "cm")

