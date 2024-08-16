df <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-08-20/english_monarchs_marriages_df.csv')

# Look at the variables
str(df)

library(dplyr)
library(stringr)

# Let's convert some variables to numeric
df <- mutate(
  df,
  across(
    c(king_age, consort_age, year_of_marriage),
  as.numeric)
)

# Age difference
df <- mutate(df, age_diff = king_age - consort_age)

# Summarize number of marriages where consort was older - age_diff < 0
older <- filter(df, age_diff < 0) |> nrow()
tot <- nrow(df)

# Get max and min
midpoint <- 0
max <- max(df$age_diff, na.rm = T)
max.year <- max(df$year_of_marriage, na.rm = T)
min.year <- min(df$year_of_marriage, na.rm = T)
max.which.year <- df$year_of_marriage[which.max(df$age_diff)]
max.which.king.name <- df$king_name[which.max(df$age_diff)]
max.which.consort.name <- df$consort_name[which.max(df$age_diff)]
min <- min(df$age_diff, na.rm = T)
min.which.year <- df$year_of_marriage[which.min(df$age_diff)]
min.which.king.name <- df$king_name[which.min(df$age_diff)]
min.which.consort.name <- df$consort_name[which.min(df$age_diff)]

# Prepare plot 
library(ggplot2)
library(stringr)
library(hrbrthemes)
library(ggtext)

ggplot(df) + 
  # Using the colordcale package I want to add a diverging palette zith
  # midpoint = 0
  # endpoint = -12 to 40
  geom_point(
    aes(
      x = year_of_marriage,
      y = age_diff,
      color = age_diff, 
      size = abs(age_diff))#,  alpha = 0.6
  ) +
  scale_size_area(max_size = 10) +
  # scale_color_continuous_divergingx(palette = 'RdBu', mid = 0, cmax2 = 40, cmax1 = 0) +
  scale_color_gradientn(
    colors = c("#3d5941", "#f6edbd", "#ca562c"),   # Define the colors at specific points
    values = scales::rescale(c(-12, 0, 40)),  # Rescale the values from -12 to 40
    limits = c(-12, 40)                   # Set the limits to match your endpoints
  ) +
  # Geom curve and text for max
  annotate(
    geom = "text",
    x = max.which.year + 320,
    y = max - 3,
    label = str_wrap(paste0(max.which.king.name, " was ", abs(max), " years older than consort ", max.which.consort.name, ". "), 35),
    color = "#ca562c",
    size = 4.5,
    halign = 0.5
  ) +
  annotate(
    geom = "curve",
    x = max.which.year + 150,
    y = max - 3,
    xend = max.which.year + 25,
    yend = max - 0.5,
    color = "#ca562c",
    arrow = arrow(length = unit(0.01, "npc")), curvature = -0.1) +
  annotate(
    geom = "text",
    x = min.which.year - 250,
    y = min - 3,
    label = str_wrap(paste0(min.which.king.name, " was ", abs(min), " years younger than consort ", min.which.consort.name), 30),
    color = "#3d5941",
    size = 4.5,
    halign = 0.5
  ) +
  annotate(
    geom = "curve",
    x = min.which.year - 100,
    y = min - 3,
    xend = min.which.year - 10,
    yend = min - 1,
    color = "#3d5941",
    curvature = 0.3,
    arrow = arrow(length = unit(0.01, "npc"))) +
  # remove the legend for size aes
  guides(size = "none") +
  # remove the guide title for color aes  
  labs(
    x = "Year of Marriage",
    y = "Age Difference",
    title = "Marriage Age Differences between English Monarchs and Consorts",
    subtitle = str_wrap(paste0("From ", min.year, " to ", max.year, ", Consorts were", "<b><span style='color:#3d5941'>"," older", " </span></b>", "than the Monarchs for ", "<b><span style='color:#3d5941'>", older, " marriages</span></b>."), 75),
    caption = "Data: https://github.com/rfordatascience/tidytuesday/tree/master/data/2024/2024-08-20"
    ) + 
  theme_ipsum_rc(base_size = 14) +
  # we want to see the minus 10 tick add limits to 20
  scale_y_continuous(breaks = seq(-20, 40, 10), limits = c(-20, 45)) +
  # theme
  theme(
    legend.title = element_blank(),
    axis.title.y = element_blank(),
    axis.title.x = element_blank(),
    # increase size of y axis text
    axis.text = element_text(size = 13),
    # increqse size of title
    plot.title = element_markdown(size = 20),
    # increase size of subtitle
    plot.subtitle = element_markdown(size = 18)
  ) 
# Save svg
ggsave("2024/2024-08-20.svg", plot = last_plot(), width = 30, height = 18, units = "cm")
      #3d5941,#778868,#b5b991,#f6edbd,#edbb8a,#de8a5a,#ca562c


