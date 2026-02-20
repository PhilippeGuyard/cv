 # Philippe Guyard - CV

Professional CV in multiple formats:
- **PDF:** Build locally with `./build.sh` or download from [workflow artifacts](https://github.com/PhilippeGuyard/cv/actions)
- **Web:** [https://philippeguyard.github.io/cv/](https://philippeguyard.github.io/cv/) - Online version

**Note:** The PDF is not committed to the repository as it contains personal contact information (email and phone). Build it locally or download from GitHub Actions artifacts.

## Setup

### Environment Variables

Contact information is stored in environment variables for security:

1. Copy the example file:
```bash
cp .env.example .env
```

2. Edit `.env` with your contact details:
```bash
CV_EMAIL="your.email@example.com"
CV_PHONE="+44 1234 567890"
```

**Note:** Never commit `.env` to git! It's in `.gitignore`.

### GitHub Secrets

For automated builds, add these secrets to your repository:
1. Go to Settings → Secrets and variables → Actions
2. Add `CV_EMAIL` and `CV_PHONE` secrets

## Building Locally

### LaTeX PDF
```bash
make pdf
```

This uses `build.sh` which:
- Loads environment variables from `.env`
- Injects them into the LaTeX template
- Builds the PDF

Or manually:
```bash
./build.sh
```

### Web Version
Open `index.html` in browser or serve locally:
```bash
python -m http.server 8000
```

**Privacy:** The web version doesn't include email/phone. Full contact info is in the PDF.

## Tech Stack
- LaTeX for PDF generation
- HTML5/CSS3 for web version
- GitHub Actions for automated builds
- GitHub Pages for hosting
- Environment variables for sensitive data

## How This CV Was Made

This CV itself demonstrates full-stack development, CI/CD automation, and infrastructure-as-code principles:

### Architecture

**Dual-Format Publishing System**
```
Source (Single Source of Truth)
├── philippe-guyard-cv.tex.template  # LaTeX source with env var placeholders
└── index.html + style.css           # Semantic HTML/CSS web version

Build Pipeline
├── Local: build.sh → Docker → pdflatex → PDF → Manual commit
└── CI/CD: GitHub Actions → LaTeX container → PDF → Artifact upload

Deployment
├── PDF: Not in repo (contains personal info), available as workflow artifact
└── Web: GitHub Pages with automated deployment (no contact info)
```

**Technology Stack**
- **PDF Generation**: LaTeX with custom typography (Helvetica, Swiss/International design)
- **Web Frontend**: HTML5 semantic markup, CSS3 with system fonts, mobile-responsive
- **Build Automation**: Shell scripting (`build.sh`), Docker containers, GNU Make
- **CI/CD**: GitHub Actions with LaTeX Docker images, automated commits
- **Secrets Management**: Environment variables (`.env` local, GitHub Secrets for CI)
- **Hosting**: GitHub Pages with automatic deployment on push

### Build Pipeline

**Local Development**
```bash
# 1. Environment variables loaded from .env
source .env

# 2. Template placeholders replaced with actual values
sed 's/{{CV_EMAIL}}/$CV_EMAIL/g' template > source.tex

# 3. LaTeX compilation (via Docker if pdflatex unavailable)
pdflatex source.tex → philippe-guyard-cv.pdf
```

**CI/CD Workflow** (`.github/workflows/build-cv.yml`)
```yaml
on:
  push:
    paths: ['philippe-guyard-cv.tex.template', 'build.sh']

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      CV_EMAIL: ${{ secrets.CV_EMAIL }}
      CV_PHONE: ${{ secrets.CV_PHONE }}
    steps:
      - Checkout code
      - Inject secrets into template via sed
      - Compile LaTeX using xu-cheng/latex-action@v3
      - Upload PDF as workflow artifact (90 day retention)
```

**Web Deployment** (`.github/workflows/pages.yml`)
```yaml
on:
  push:
    paths: ['index.html', 'style.css', '*.pdf']

jobs:
  deploy:
    permissions:
      contents: read
      pages: write
      id-token: write
    steps:
      - Upload entire directory as artifact
      - Deploy to GitHub Pages using deploy-pages@v4
```

### Security & Best Practices

**Secrets Management**
- Contact info never committed to git (`.env` in `.gitignore`)
- GitHub Secrets used for CI/CD builds
- Template-based approach prevents accidental exposure
- Separate `.env.example` for onboarding

**Privacy by Design**
- Web version omits email/phone (public internet)
- PDF version includes full contact info (for applications)
- Clear separation of public vs. private data

**ATS Optimization**
- Semantic HTML for web version (proper `<section>`, `<h1-h3>` hierarchy)
- LaTeX output tested with `pdftotext` for clean extraction
- No complex layouts or tables that confuse parsers
- Standard fonts and formatting

### Key Engineering Decisions

**Why Dual Format?**
- PDF: Pixel-perfect control, professional quality, offline distribution
- Web: SEO-friendly, always accessible, mobile-responsive, easy sharing

**Why LaTeX over PDF libraries?**
- Superior typography and spacing control
- Industry standard for professional documents
- Reproducible builds across environments
- Easy version control (text-based)

**Why Template + Build Script?**
- Single source of truth for content
- Secrets injected at build time (never stored)
- Same workflow local and CI/CD
- Docker ensures consistency across environments

**Why GitHub Actions?**
- Automatic builds on template changes
- No manual PDF compilation required
- Version control for all artifacts
- Free for public repositories

### File Structure
```
cv/
├── .github/workflows/
│   ├── build-cv.yml          # PDF build pipeline
│   └── pages.yml             # Web deployment
├── philippe-guyard-cv.tex.template  # LaTeX source (with {{placeholders}})
├── build.sh                  # Build script (env var injection + pdflatex)
├── index.html                # Web version (semantic HTML5)
├── style.css                 # Web styling (minimal, responsive)
├── .env.example              # Template for local secrets
└── docs/plans/               # Design docs and specifications
```

### Metrics
- **Build time**: ~1 minute (LaTeX compilation + PDF generation)
- **PDF size**: 48KB (optimized, embedded fonts)
- **Web bundle**: <15KB (HTML + CSS, no JavaScript)
- **Pages**: 2 pages (optimized spacing)
- **CI/CD**: Zero-downtime deployments

This CV is itself a demonstration of modern software engineering practices: automation, security, reproducible builds, and infrastructure-as-code.

