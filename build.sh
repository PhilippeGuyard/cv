#!/bin/bash
set -e

# Load environment variables from .env if it exists
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

# Check required environment variables
if [ -z "$CV_EMAIL" ] || [ -z "$CV_PHONE" ]; then
  echo "Error: CV_EMAIL and CV_PHONE must be set"
  echo "Either set them in .env file or as environment variables"
  exit 1
fi

# Create .tex file with injected values from template
sed -e "s|{{CV_EMAIL}}|$CV_EMAIL|g" \
    -e "s|{{CV_PHONE}}|$CV_PHONE|g" \
    philippe-guyard-cv.tex.template > philippe-guyard-cv.tex

# Build PDF
# Check if running in Docker or if pdflatex is available
if command -v pdflatex > /dev/null 2>&1; then
  pdflatex philippe-guyard-cv.tex
else
  # Use Docker if pdflatex not available
  docker run --rm -v "$(pwd):/workspace" -w /workspace blang/latex:ubuntu pdflatex philippe-guyard-cv.tex
fi

echo "PDF built successfully with contact info from environment variables"
