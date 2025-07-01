# TidyTuesday

A collection of visualizations for Tidy Tuesdays, built as a Quarto website with R and Python support.

## 🌐 Website

Visit the live website: [here](https://gnoblet.github.io/TidyTuesday/)

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

### Quick Template Creation

Use the included script to generate a new visualization from the template:

```bash
# Create a new R analysis
./new-viz-from-template.sh 2024-12-15 r "Coffee Analysis"

# Create a new Python analysis  
./new-viz-from-template.sh 2024-12-15 python "Climate Data Study"

# Example with single word title
./new-viz-from-template.sh 2024-12-20 r "Olympics"
```

**Arguments:**
- `date`: Date in YYYY-MM-DD format (e.g., 2024-12-15)
- `language`: Programming language ('r' or 'python')
- `title`: Title for the analysis (use quotes if it contains spaces)

This will create:
- A `.qmd` file in `r/` or `python/` directory with a complete template
- All placeholders automatically replaced with your specified values
- Ready-to-edit analysis structure

### Template Structure

Each generated visualization includes:

- **Overview**: Description of the analysis and approach
- **Dataset**: Data loading and exploration
- **Analysis**: Data preparation and key insights
- **Visualization**: Main plots and additional analysis
- **Technical Notes**: Tools, libraries, and methodology
- **Viz**: The output viz

### Manual Creation

You can also manually create new visualizations:

1. Copy `template.qmd` to your desired location
2. Replace all `{{PLACEHOLDER}}` values
3. Add your analysis code
4. Render with `quarto render filename.qmd`

### Automatic Gallery Integration

- **New analyses automatically appear** in the gallery when you render the site
- **No manual updates needed** - the gallery scans for .qmd files dynamically
- **Consistent formatting** across all projects

### Manual Setup

#### R Environment (renv)
```bash
# Restore R packages
R -e "renv::restore()"
```

#### Python Environment (uv)
```bash
# Create virtual environment
uv venv .venv
source .venv/bin/activate

# if using fish instead of bash
source .venv/bin/activate.fish

# Install dependencies
uv sync
```

#### Build Website
```bash
# Render the website
quarto render

# Preview locally
quarto preview
```

## 📁 Project Structure

```
├── .github/workflows/    # GitHub Actions for deployment
├── r/                   # R project pages (Quarto)
├── python/              # Python project pages (Quarto)
├── _site/               # Generated website (ignored)
├── renv/                # R environment
├── .venv/               # Python virtual environment (ignored)
├── requirements.txt     # Python dependencies
├── renv.lock           # R package lockfile
└── _quarto.yml         # Quarto configuration
```

## 🔄 Deployment

The website is automatically deployed to GitHub Pages when changes are pushed to the main branch. The GitHub Actions workflow:

1. Sets up R with renv for package management
2. Sets up Python with uv for package management
3. Installs system dependencies
4. Renders the Quarto website
5. Deploys to GitHub Pages

## 📊 Adding New Projects

### R Projects
1. Add a corresponding Quarto document in `r/YYYY-MM-DD.qmd`
2. Update `_quarto.yml` sidebar navigation (automated via ./new-viz-from-template.sh)

### Python Projects
1. Add a corresponding Quarto document in `python/YYYY-MM-DD.qmd`
2. Update `_quarto.yml` sidebar navigation (automated via ./new-viz-from-template.sh)

## 🛠️ Package Management

- **R packages**: Managed by [renv](https://rstudio.github.io/renv/)
- **Python packages**: Managed by [uv](https://docs.astral.sh/uv/)
- **Repository**: Fast Linux binaries from [p3m.dev](https://p3m.dev/)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
