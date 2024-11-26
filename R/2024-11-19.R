# Setup box
box::use(
  rio[import],
  purrr[accumulate],
  dyr = dplyr,
  tyr = tidyr,
  sgr = stringr,
  gg = ggplot2,
  ggt = ggtext,
  ggh4x,
  gghrbr = hrbrthemes
)

# Get data
df <- rio::import('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-11-19/episode_metrics.csv')

# Create index by season and episode
df <- df |>
  dyr$arrange(season, episode) |>
  dyr$mutate(n = dyr$row_number())

# Main function
vars <- c("avg_length", "dialogue_density", "sentiment_variance", "unique_words", "question_ratio", "exclamation_ratio")

df_gg <- main(df, "n", vars)

main <- function(df, step, vars){

  df <- vapply_base_100(df, step, vars)
  vars_b100 <- paste0(vars, "_b100")
  df <- tyr$pivot_longer(df, cols = c(vars_b100), names_to = "var", values_to = "value") |> 
    dyr$select(season, episode, n, var, value)

  return(df)
}

# Apply base_100 to columns avg_length and dialogue_density using the apply family
vapply_base_100 <- function(df, step, vars) {

  for (var in vars) {
    df <- base_100(df, "n", var)
  }

  return(df)
}

# Base 100 for dialogue density when n = 1
base_100 <- function(df, step, var, suffix = "_b100") {

  min_step_row <- which.min(df[[step]])
  first_col_value <- df[[var]][min_step_row]
  new_var <- paste0(var, suffix)
  df[[new_var]] <- df[[var]] / first_col_value * 100

  return(df)
  
}



# Look at the variables
str(df)

# ggplot to draw a geom line by season, for one var

df_gg |> 
  # dyr$filter(var == "avg_length_b100") |>
  gg$ggplot(gg$aes(x = n, y = value)) +
  gg$geom_line() +
  gg$scale_y_continuous(breaks = seq(0, 150, 50)) +
  gg$facet_wrap(~var, nrow = 6, scales = "fixed", strip.position = "right") +
  gg$guides(
    x = ggh4x::guide_axis_nested()
  )
  gg$theme_minimal() +
  gg$labs(
    x = NULL,
    y = NULL,
    title = "Title",
    subtitle = "Subtitle",
    caption = "Caption"
  ) +
  # Add seasons vertical lines
  gg$geom_vline(xintercept = df_gg |>
    dyr$group_by(season) |>
    dyr$summarize(n = min(n)) |> 
    dyr$pull(n), linetype = "dashed")
  


ggline <- function(
  df,
  xvar,
  yvar,
  title = NULL,
  subtitle = NULL,
  caption = NULL
){
  gg$ggplot(df) +
    gg$aes(x = {{xvar}}, y = {{yvar}}, color = {{color}}) +
    gg$geom_line() +
    gg$labs(
      x = NULL,
      y = NULL,
      title = title,
      subtitle = subtitle,
      caption = caption
    )
}
