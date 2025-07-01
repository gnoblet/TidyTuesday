#!/bin/bash

# Script to create a new TidyTuesday visualization from template
# Usage: ./new-viz-from-template.sh <date> <language> <title>
# Example: ./new-viz-from-template.sh 2024-12-10 r "Coffee Data Analysis"
# Creates structure: r/2024/week_XX/week_XX.qmd

set -e

# Function to calculate week number from date
get_week_number() {
    local date=$1
    # Convert date to week number (ISO week)
    local week=$(date -d "$date" +%V)
    # Remove leading zero if present
    week=$((10#$week))
    # Remove as it is for the week before
    week=$((week - 1))
    echo $week
}

# Check arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <date> <language> <title>"
    echo "Example: $0 2024-12-10 r 'Coffee Data Analysis'"
    echo "Language options: r, python"
    echo ""
    echo "Creates structure: language/YYYY/week_XX/week_XX.qmd"
    exit 1
fi

DATE=$1
LANGUAGE=$2
TITLE=$3

# Validate language
if [[ "$LANGUAGE" != "r" && "$LANGUAGE" != "python" ]]; then
    echo "Error: Language must be 'r' or 'python'"
    exit 1
fi

# Validate date format
if ! echo "$DATE" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
    echo "Error: Date must be in YYYY-MM-DD format"
    exit 1
fi

# Extract year and calculate week number
YEAR=$(echo $DATE | cut -d'-' -f1)
WEEK_NUM=$(get_week_number $DATE)
WEEK_DIR="week_${WEEK_NUM}"
WEEK_FILE="${WEEK_DIR}.qmd"

# Create the folder structure
LANG_DIR="${LANGUAGE}/${YEAR}/${WEEK_DIR}"
QMD_FILE="${LANG_DIR}/${WEEK_FILE}"

# Create directories
mkdir -p "$LANG_DIR"

if [ -f "$QMD_FILE" ]; then
    echo "Error: File $QMD_FILE already exists"
    exit 1
fi

# Copy template and replace placeholders
cp template.qmd "$QMD_FILE"

# Replace placeholders based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/{{TITLE}}/$TITLE/g" "$QMD_FILE"
    sed -i '' "s/{{DATE}}/$DATE/g" "$QMD_FILE"
    sed -i '' "s/{{LANGUAGE}}/$LANGUAGE/g" "$QMD_FILE"
    if [ "$LANGUAGE" = "r" ]; then
        sed -i '' "s/{{LANGUAGE_UPPER}}/R/g" "$QMD_FILE"
        sed -i '' "s/{{LANGUAGE_CODE}}/r/g" "$QMD_FILE"
        sed -i '' "s/{{LANGUAGE_EXT}}/R/g" "$QMD_FILE"
        sed -i '' "s/{{CATEGORIES}}/ggplot2, tidyverse, data-viz/g" "$QMD_FILE"
        sed -i '' "s/{{TOOLS_USED}}/R, ggplot2, tidyverse/g" "$QMD_FILE"
        sed -i '' "s/{{KEY_LIBRARIES}}/ggplot2, dplyr, tidyr/g" "$QMD_FILE"
        sed -i '' "s/{{IMAGE_FILE}}/plot.svg/g" "$QMD_FILE"
        # Update image path to use new structure
        sed -i '' "s|../R/${DATE}/plot.svg|../R/${YEAR}/${WEEK_DIR}/plot.svg|g" "$QMD_FILE"
    else
        sed -i '' "s/{{LANGUAGE_UPPER}}/Python/g" "$QMD_FILE"
        sed -i '' "s/{{LANGUAGE_CODE}}/python/g" "$QMD_FILE"
        sed -i '' "s/{{LANGUAGE_EXT}}/py/g" "$QMD_FILE"
        sed -i '' "s/{{CATEGORIES}}/matplotlib, pandas, data-viz/g" "$QMD_FILE"
        sed -i '' "s/{{TOOLS_USED}}/Python, pandas, matplotlib, seaborn/g" "$QMD_FILE"
        sed -i '' "s/{{KEY_LIBRARIES}}/pandas, matplotlib, seaborn/g" "$QMD_FILE"
        sed -i '' "s/{{IMAGE_FILE}}/plot.png/g" "$QMD_FILE"
        # Update image path to use new structure
        sed -i '' "s|../Python/${DATE}/plot.png|../Python/${YEAR}/${WEEK_DIR}/plot.png|g" "$QMD_FILE"
    fi
else
    # Linux
    sed -i "s/{{TITLE}}/$TITLE/g" "$QMD_FILE"
    sed -i "s/{{DATE}}/$DATE/g" "$QMD_FILE"
    sed -i "s/{{LANGUAGE}}/$LANGUAGE/g" "$QMD_FILE"
    if [ "$LANGUAGE" = "r" ]; then
        sed -i "s/{{LANGUAGE_UPPER}}/R/g" "$QMD_FILE"
        sed -i "s/{{LANGUAGE_CODE}}/r/g" "$QMD_FILE"
        sed -i "s/{{LANGUAGE_EXT}}/R/g" "$QMD_FILE"
        sed -i "s/{{CATEGORIES}}/ggplot2, tidyverse, data-viz/g" "$QMD_FILE"
        sed -i "s/{{TOOLS_USED}}/R, ggplot2, tidyverse/g" "$QMD_FILE"
        sed -i "s/{{KEY_LIBRARIES}}/ggplot2, dplyr, tidyr/g" "$QMD_FILE"
        sed -i "s/{{IMAGE_FILE}}/plot.svg/g" "$QMD_FILE"
        # Update image path to use new structure
        sed -i "s|../R/${DATE}/plot.svg|../R/${YEAR}/${WEEK_DIR}/plot.svg|g" "$QMD_FILE"
    else
        sed -i "s/{{LANGUAGE_UPPER}}/Python/g" "$QMD_FILE"
        sed -i "s/{{LANGUAGE_CODE}}/python/g" "$QMD_FILE"
        sed -i "s/{{LANGUAGE_EXT}}/py/g" "$QMD_FILE"
        sed -i "s/{{CATEGORIES}}/matplotlib, pandas, data-viz/g" "$QMD_FILE"
        sed -i "s/{{TOOLS_USED}}/Python, pandas, matplotlib, seaborn/g" "$QMD_FILE"
        sed -i "s/{{KEY_LIBRARIES}}/pandas, matplotlib, seaborn/g" "$QMD_FILE"
        sed -i "s/{{IMAGE_FILE}}/plot.png/g" "$QMD_FILE"
        # Update image path to use new structure
        sed -i "s|../Python/${DATE}/plot.png|../Python/${YEAR}/${WEEK_DIR}/plot.png|g" "$QMD_FILE"
    fi
fi

# Add the new file to _quarto.yml contents
if [ "$LANGUAGE" = "r" ]; then
    # Add to R Projects section
    if grep -q "R Projects" _quarto.yml; then
        # Find the last R project line and add after it
        LAST_R_LINE=$(grep -n "r/.*\.qmd" _quarto.yml | tail -1 | cut -d: -f1)
        if [ ! -z "$LAST_R_LINE" ]; then
            sed -i "${LAST_R_LINE}a\\            - ${QMD_FILE}" _quarto.yml
        else
            # If no R files found, add after the R Projects contents line
            R_CONTENTS_LINE=$(grep -n "R Projects" _quarto.yml | cut -d: -f1)
            R_CONTENTS_LINE=$((R_CONTENTS_LINE + 2))
            sed -i "${R_CONTENTS_LINE}a\\            - ${QMD_FILE}" _quarto.yml
        fi
    fi
else
    # Add to Python Projects section
    if grep -q "Python Projects" _quarto.yml; then
        # Find the last Python project line and add after it
        LAST_PY_LINE=$(grep -n "python/.*\.qmd" _quarto.yml | tail -1 | cut -d: -f1)
        if [ ! -z "$LAST_PY_LINE" ]; then
            sed -i "${LAST_PY_LINE}a\\            - ${QMD_FILE}" _quarto.yml
        else
            # If no Python files found, add after the Python Projects contents line
            PY_CONTENTS_LINE=$(grep -n "Python Projects" _quarto.yml | cut -d: -f1)
            PY_CONTENTS_LINE=$((PY_CONTENTS_LINE + 2))
            sed -i "${PY_CONTENTS_LINE}a\\            - ${QMD_FILE}" _quarto.yml
        fi
    fi
fi

echo "✅ Created new visualization: $QMD_FILE"
echo "✅ Added to _quarto.yml sidebar"
echo "📁 Folder structure: ${LANG_DIR}/"
echo ""
echo "🚀 Next steps:"
echo "   1. Edit $QMD_FILE to add your analysis"
echo "   2. Save visualizations to ${LANGUAGE^}/${YEAR}/${WEEK_DIR}/ directory"
echo "   3. Update the image path in YAML if needed"
echo "   4. Run 'quarto render' to build the site"
echo ""
echo "💡 Week info:"
echo "   - Date: $DATE (Week $WEEK_NUM of $YEAR)"
echo "   - Structure: ${LANGUAGE}/${YEAR}/${WEEK_DIR}/${WEEK_FILE}"
