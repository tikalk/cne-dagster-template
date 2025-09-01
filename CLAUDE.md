# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Local Development Setup
```bash
# Clone with submodules
git clone --recurse-submodules <repository-url>

# If already cloned, initialize submodules
git submodule update --init --recursive

# Set up virtual environment with uv
uv venv
source .venv/bin/activate
uv pip install -r requirements.txt

# Run Dagster development server
dagster dev -h 0.0.0.0 -p 3000
```

### Docker Commands
```bash
# Build Docker image
docker build -t cne-dagster-template .

# Run with environment variables
docker run -p 3000:3000 --env-file .env cne-dagster-template
```

### Testing and Validation
The project uses dbt for data transformations. Key validation commands:
```bash
# Navigate to dbt project directory
cd cne-dbt-template

# Install dbt dependencies
dbt deps

# Parse dbt project
dbt parse

# Build dbt models
dbt build
```

## Architecture Overview

This is a **Dagster + dbt** data orchestration project that uses **BigQuery** as the data warehouse.

### Key Components

- **`cne_dagster/`** - Main Dagster project
  - `definitions.py` - Entry point defining assets, schedules, and resources
  - `assets.py` - Defines dbt assets using `@dbt_assets` decorator
  - `schedules.py` - Contains schedule definitions (commented out by default)
  - `project.py` - **Missing file** - should contain dbt project configuration

- **`cne-dbt-template/`** - dbt project as git submodule for data transformations

### Configuration Requirements

Environment variables needed in `.env` file:
- `DBT_PROFILE_PROJECT` - dbt project name
- `DBT_PROFILE` - dbt profile name  
- `BIGQUERY_DATABASE` - BigQuery database
- `DATASET_PREFIX` - Dataset prefix
- `TARGET_NAME` - Target environment (dev/prod)
- `BIGQUERY_KEYFILE_PATH` - Path to service account JSON
- `SOURCE_DATABASE` - Source database name
- `BIGQUERY_ACCOUNT` - BigQuery account

BigQuery service account key must be placed in `.keys/staging.json`.

### Integration Pattern

The project uses `dagster-dbt` integration where:
1. dbt models are automatically converted to Dagster assets
2. `DbtCliResource` executes dbt commands through Dagster
3. Assets are materialized using `dbt build` command
4. Schedules can be created from dbt selections

### Missing Components

- `cne_dagster/cne_dagster/project.py` file is missing (shows as deleted in git status)
- This file should contain the dbt project configuration and manifest path

## Development Notes

- Uses Python 3.11+ (root pyproject.toml specifies >=3.13, but inner one uses >=3.9,<3.13)
- Project structure follows Dagster + dbt best practices
- CI/CD via GitHub Actions builds and pushes Docker images
- Dagster UI runs on port 3000