# TidyTuesday

A collection of visualizations for Tidy Tuesdays, built as a Quarto website with R and Python support.

## 🌐 Website

Visit the live website: [here](https://guillaume-noblet.com/TidyTuesday/)

## 🚀 Development Setup

### Prerequisites

- [R](https://www.r-project.org/) (≥4.4.0)
- [Python](https://www.python.org/) (≥3.13)
- [Quarto](https://quarto.org/)
- [uv](https://docs.astral.sh/uv/) (Python package manager)

### Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/gnoblet/TidyTuesday.git
   cd TidyTuesday
   ```

2. Run the setup script:
   ```bash
   ./setup-dev.sh
   ```

3. Preview the website:
   ```bash
   quarto preview
   ```

## 📝 Creating New Visualizations


Use the included script to generate a new visualization from the template in R:

```bash
# Create a new R post from the template
# Usage:
#   Rscript posts/new-viz-from-template.R [-c "categories"] [-u "tools used"] [-k "key libraries"] [-f image_file] <date> <title>
#
# Notes:
#  - Creates: posts/<YEAR>/week_<N>/week_<N>.qmd
#  - Default image filename: weekNN.png (zero-padded) placed inside that week folder, e.g. posts/2025/week_01/week01.png
#  - The script replaces placeholders in template.qmd; ensure template.qmd is present.
#  - The script will update _quarto.yml to add the new post entry when possible.
#  - Week number = ISO week of the date minus one (keeps existing behavior).

# Examples
# Minimal (uses defaults and weekXX.png):
Rscript new-viz-from-template.R 2025-01-07 "Coffee Analysis"

# With metadata flags and explicit image name:
Rscript new-viz-from-template.R \
  -c "ggplot2, tidyverse" \
  -u "R, ggplot2, tidyverse" \
  -k "ggplot2, dplyr, tidyr" \
  -f week01.png \
  2025-01-07 "Coffee Analysis"

# If you only want to override the image name:
Rscript new-viz-from-template.R -f custom-plot.png 2025-01-07 "Coffee Analysis"

# Quick help:
Rscript new-viz-from-template.R -h
```

**Arguments:**
- `date`: Date in YYYY-MM-DD format (e.g., 2024-12-15)
- `title`: Title for the analysis (use quotes if it contains spaces)
- `-c "categories"`: Comma-separated categories (default: "TidyTuesday")
- `-u "tools used"`: Comma-separated tools used (default: "R
- `-k "key libraries"`: Comma-separated key libraries (default: "ggplot2, dplyr")
- `-f image_file`: Filename for the main visualization image (default: weekNN.png

This will create:
- A `.qmd` file in the `posts/` directory with a complete template
- All placeholders automatically replaced with your specified values
- Ready-to-edit analysis structure


## Automatic Gallery Integration

- **New analyses automatically appear** in the gallery when you render the site
- **No manual updates needed** - the gallery scans for .qmd files dynamically
- **Consistent formatting** across all projects

## Manual Setup

### R Environment (renv)
```bash
# Restore R packages
R -e "renv::restore()"
```

### Python Environment (uv)
```bash
# Create virtual environment
uv venv .venv
source .venv/bin/activate

# if using fish instead of bash
source .venv/bin/activate.fish

# Install dependencies
uv sync
```

### Build Website
```bash
# Render the website
quarto render

# Preview locally
quarto preview
```

## 📁 Project Structure

```
├── .github/workflows/   # GitHub Actions for deployment
├── posts/               # Project posts (Quarto)
├── _site/               # Generated website (ignored)
├── renv/                # R environment
├── .venv/               # Python virtual environment (ignored)
├── requirements.txt     # Python dependencies
├── renv.lock            # R package lockfile
└── _quarto.yml          # Quarto configuration
```

## 🔄 Deployment

The website is automatically deployed to GitHub Pages when changes are pushed to the main branch. The GitHub Actions workflow:

1. Sets up R with renv for package management
2. Sets up Python with uv for package management
3. Installs system dependencies
4. Renders the Quarto website
5. Deploys to GitHub Pages


## 🛠️ Package Management

- **R packages**: Managed by [renv](https://rstudio.github.io/renv/)
- **Python packages**: Managed by [uv](https://docs.astral.sh/uv/)
- **Repository**: Fast Linux binaries from [p3m.dev](https://p3m.dev/)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
