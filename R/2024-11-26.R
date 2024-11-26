# Setup box
box::use(
  rio[import],
  purrr[accumulate],
  dplyr[bind_rows, mutate],
  tidyr[pivot_longer],
  lubridate[make_date],
  forcats[fct_recode]
  # tyr = tidyr,
  # sgr = stringr,
  # gg = ggplot2,
  # ggt = ggtext,
  # ggh4x,
  # gghrbr = hrbrthemes
)

# Get data
resp <- rio::import('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-11-26/cbp_resp.csv')
state <- rio::import('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-11-26/cbp_state.csv')

# First plot, let's look out by type demogrqphic
library(ggplot2)
month_to_num = c("JAN" = 1, "FEB" = 2, "MAR" = 3, "APR" = 4, "MAY" = 5, "JUN" = 6, "JUL" = 7, "AUG" = 8, "SEP" = 9, "OCT" = 10, "NOV" = 11, "DEC" = 12)
num_to_month = setNames(names(month_to_num), month_to_num)
resp$month <- fct_recode(resp$month_abbv, !!!num_to_month) 
resp$year_month <- make_date(year = resp$fiscal_year, month = resp$month)

  #group_by(fiscal_year, demographic) |>
  #summarise(n = n()) |>
  #pivot_longer(cols = fiscal_year, names_to = "var", values_to = "n") |>

resp |> group_by(year_month, demographic) |>
  summarise(n = sum(encounter_count, na.rm = T)) |>
  ggplot() +
  aes(x = year_month, y = n, fill = demographic) + 
  geom_col()
