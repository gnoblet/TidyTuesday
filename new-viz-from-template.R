#!/usr/bin/env Rscript
# new-viz-from-template.R
# Usage:
#   Rscript new-viz-from-template.R [-c "categories"] [-u "tools used"] [-k "key libraries"] [-f image_file] <date>

args <- commandArgs(trailingOnly = TRUE)

usage <- function() {
  cat("Usage:\n")
  cat(
    "  Rscript new-viz-from-template.R <date>\n"
  )
  quit(status = 1)
}

DATE <- args[1]

if (!grepl("^\\d{4}-\\d{2}-\\d{2}$", DATE)) {
  stop("Date must be in YYYY-MM-DD format")
}

# defaults for R metadata
opts <- list()
opts$categories <- "ggplot2, tidyverse, data-viz"
opts$tools <- "R, ggplot2, tidyverse"
opts$keylibs <- "ggplot2, dplyr, tidyr"

YEAR <- substr(DATE, 1, 4)
WEEK <- as.integer(format(as.Date(DATE), "%W"))
if (is.na(WEEK)) {
  WEEK <- 0
  warn("week is missing, using 0.")
}
WEEK_DIR <- paste0("week_", WEEK)
WEEK_FILE <- paste0(WEEK_DIR, ".qmd")
WEEK_RPROFILE <- paste0(".Rprofile")

# default image name: weekNN.png (zero-padded)
default_image <- sprintf("week%02d.png", WEEK)
opts$image <- default_image

# Place the post inside posts/<YEAR>/week_<N>/
LANG_DIR <- file.path("posts", YEAR, WEEK_DIR)
QMD_FILE <- file.path(LANG_DIR, WEEK_FILE)
RPROFILE_FILE <- file.path(LANG_DIR, WEEK_RPROFILE)

if (!dir.exists(LANG_DIR)) {
  dir.create(LANG_DIR, recursive = TRUE, showWarnings = FALSE)
}
if (file.exists(QMD_FILE)) {
  stop(sprintf("Error: File %s already exists", QMD_FILE))
}
if (file.exists(QMD_FILE)) {
  stop(sprintf("Error: File %s already exists", RPROFILE_FILE))
}
if (!file.exists("template.qmd")) {
  stop("template.qmd not found in current directory")
}

file.copy("template.qmd", QMD_FILE, overwrite = FALSE)
lines <- readLines(QMD_FILE, warn = FALSE)

url <- paste0(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/",
  YEAR,
  "/",
  DATE,
  "/readme.md"
)
readme <- readLines(url)

repls <- list(
  "{{TITLE}}" = readme[1],
  "{{DATE}}" = DATE,
  "{{WEEK}}" = WEEK,
  "{{YEAR}}" = YEAR,
  "{{LANGUAGE}}" = "r",
  "{{LANGUAGE_UPPER}}" = "R",
  "{{LANGUAGE_CODE}}" = "r",
  "{{LANGUAGE_EXT}}" = "R",
  "{{CATEGORIES}}" = opts$categories,
  "{{TOOLS_USED}}" = opts$tools,
  "{{KEY_LIBRARIES}}" = opts$keylibs,
  "{{IMAGE_FILE}}" = opts$image,
  "{{DESC}}" = readme[3]
)

for (ph in names(repls)) {
  lines <- gsub(ph, repls[[ph]], lines, fixed = TRUE)
}

writeLines(lines, QMD_FILE)
writeLines("source('../../../.Rprofile')", RPROFILE_FILE)

cat(sprintf("✅ Created new visualization: %s\n", QMD_FILE))
cat(sprintf("📁 Folder structure: %s/\n", LANG_DIR))
cat("\nNext steps:\n")
cat(" 1. Edit the new qmd file to add your analysis\n")
cat(sprintf(" 2. Save the image as %s inside %s\n", opts$image, LANG_DIR))
cat(" 3. Run 'quarto render' to build the site\n")
