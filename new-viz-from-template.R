#!/usr/bin/env Rscript
# new-viz-from-template.R
# Usage:
#   Rscript new-viz-from-template.R [-c "categories"] [-u "tools used"] [-k "key libraries"] [-f image_file] <date> <title>

args <- commandArgs(trailingOnly = TRUE)

usage <- function() {
  cat("Usage:\n")
  cat(
    "  Rscript new-viz-from-template.R [-c \"categories\"] [-u \"tools used\"] [-k \"key libraries\"] [-f image_file] <date> <title>\n"
  )
  quit(status = 1)
}

# parse flags
opts <- list(categories = NULL, tools = NULL, keylibs = NULL, image = NULL)
i <- 1
while (i <= length(args) && startsWith(args[i], "-")) {
  opt <- args[i]
  if (opt %in% c("-h", "--help")) {
    usage()
  }
  if (i == length(args)) {
    cat("Missing value for option", opt, "\n")
    usage()
  }
  val <- args[i + 1]
  if (opt == "-c") {
    opts$categories <- val
  } else if (opt == "-u") {
    opts$tools <- val
  } else if (opt == "-k") {
    opts$keylibs <- val
  } else if (opt == "-f") {
    opts$image <- val
  } else {
    cat("Unknown option:", opt, "\n")
    usage()
  }
  i <- i + 2
}

pos <- if (i <= length(args)) args[i:length(args)] else character(0)
if (length(pos) != 2) {
  usage()
}
DATE <- pos[1]
TITLE <- pos[2]

if (!grepl("^\\d{4}-\\d{2}-\\d{2}$", DATE)) {
  stop("Date must be in YYYY-MM-DD format")
}

# defaults for R metadata
if (is.null(opts$categories)) {
  opts$categories <- "ggplot2, tidyverse, data-viz"
}
if (is.null(opts$tools)) {
  opts$tools <- "R, ggplot2, tidyverse"
}
if (is.null(opts$keylibs)) {
  opts$keylibs <- "ggplot2, dplyr, tidyr"
}

YEAR <- substr(DATE, 1, 4)
week_v <- as.integer(format(as.Date(DATE), "%V"))
WEEK <- week_v - 1
if (is.na(WEEK) || WEEK < 0) {
  WEEK <- 0
}
WEEK_DIR <- paste0("week_", WEEK)
WEEK_FILE <- paste0(WEEK_DIR, ".qmd")

# default image name: weekNN.png (zero-padded)
default_image <- sprintf("week%02d.png", WEEK)
if (is.null(opts$image)) {
  opts$image <- default_image
}

# Place the post inside posts/<YEAR>/week_<N>/
LANG_DIR <- file.path("posts", YEAR, WEEK_DIR)
QMD_FILE <- file.path(LANG_DIR, WEEK_FILE)

if (!dir.exists(LANG_DIR)) {
  dir.create(LANG_DIR, recursive = TRUE, showWarnings = FALSE)
}
if (file.exists(QMD_FILE)) {
  stop(sprintf("Error: File %s already exists", QMD_FILE))
}
if (!file.exists("template.qmd")) {
  stop("template.qmd not found in current directory")
}

file.copy("template.qmd", QMD_FILE, overwrite = FALSE)
lines <- readLines(QMD_FILE, warn = FALSE)

repls <- list(
  "{{TITLE}}" = TITLE,
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
  "{{IMAGE_FILE}}" = opts$image
)

for (ph in names(repls)) {
  lines <- gsub(ph, repls[[ph]], lines, fixed = TRUE)
}

writeLines(lines, QMD_FILE)

cat(sprintf("✅ Created new visualization: %s\n", QMD_FILE))
cat(sprintf("📁 Folder structure: %s/\n", LANG_DIR))
cat("\nNext steps:\n")
cat(" 1. Edit the new qmd file to add your analysis\n")
cat(sprintf(" 2. Save the image as %s inside %s\n", opts$image, LANG_DIR))
cat(" 3. Run 'quarto render' to build the site\n")
