# CNE Dagster Template

This is a template for a Dagster project that orchestrates dbt (Data Build Tool) transformations. The project is set up to use Dagster for orchestration, dbt for data transformation, and BigQuery as the data warehouse.

## Getting Started

### Prerequisites

*   Python >= 3.11, <3.13 (Python 3.13 has compatibility issues)
*   [uv](https://github.com/astral-sh/uv) (for local development)
*   Docker (optional)
*   Git

### Installation

1.  Clone the repository with the dbt submodule:

    ```bash
    git clone --recurse-submodules <repository-url>
    cd cne-dagster-template
    ```

    If you already cloned the repository, initialize the submodules:
    ```bash
    git submodule update --init --recursive
    ```

2.  Create a virtual environment and install dependencies:

    ```bash
    uv venv
    source .venv/bin/activate
    uv pip install -e .
    ```

3.  Set up BigQuery service account:
    - Obtain your BigQuery service account JSON key file
    - Create the `.keys` directory: `mkdir -p .keys`
    - Place your service account JSON file at `.keys/staging.json`

4.  Configure environment variables in the existing `.env` file:

    ```bash
    # From your BigQuery service account JSON:
    BIGQUERY_DATABASE=your_project_id           # "project_id" from JSON
    BIGQUERY_ACCOUNT=your_service_account_email # "client_email" from JSON
    
    # Path to your service account key:
    BIGQUERY_KEYFILE_PATH=.keys/staging.json
    
    # dbt configuration (customize for your project):
    DBT_PROFILE_PROJECT=your_dbt_project_name
    DBT_PROFILE=your_dbt_profile_name
    DATASET_PREFIX=dev_                          # e.g., "dev_", "staging_"
    TARGET_NAME=dev                              # or "staging", "prod"
    SOURCE_DATABASE=your_source_database_name    # often same as BIGQUERY_DATABASE
    ```

5.  Generate the dbt manifest (required before running Dagster):

    ```bash
    cd cne-dbt-template
    source ../.venv/bin/activate
    dbt deps      # Install dbt dependencies
    dbt parse     # Generate manifest.json
    cd ..
    ```

## Usage

### Local Development (Recommended)

After completing all installation steps:

```bash
# Activate the virtual environment
source .venv/bin/activate

# Navigate to the Dagster project directory
cd cne_dagster

# Run the Dagster development server
python -m dagster dev -h 0.0.0.0 -p 3000
```

The Dagster UI will be available at [http://localhost:3000](http://localhost:3000).

### Running dbt Models through Dagster

Once the server is running:

1. **Via Dagster UI** (Recommended):
   - Open [http://localhost:3000](http://localhost:3000)
   - Navigate to "Assets" in the sidebar
   - Select the dbt models you want to run
   - Click "Materialize selected" to execute them

2. **Run All Models**: Click "Materialize all" to run all dbt models at once

3. **Command Line**: You can also materialize assets programmatically:
   ```python
   from dagster import materialize
   from cne_dagster.definitions import defs
   result = materialize(defs.get_all_asset_defs())
   ```

### Docker (Optional)

To build and run the project with Docker:

```bash
# Build the Docker image
docker build -t cne-dagster-template .

# Run the Docker container with environment variables
docker run -p 3000:3000 --env-file .env cne-dagster-template
```

**Note**: When using Docker, ensure the `.keys/staging.json` file is properly included in the build context.

## Project Structure

*   `cne_dagster/`: The main Dagster project.
    *   `assets.py`: Defines the dbt assets using `@dbt_assets` decorator.
    *   `definitions.py`: Main entry point defining assets, schedules, and resources.
    *   `project.py`: Configuration for the dbt project and manifest path.
    *   `schedules.py`: Contains example schedules (commented out by default).
*   `cne-dbt-template/`: The dbt project (git submodule) containing data transformations.
    *   `target/manifest.json`: Generated dbt manifest (required for Dagster integration).
*   `.keys/`: Directory for BigQuery service account credentials.
    *   `staging.json`: BigQuery service account key file.
*   `.env`: Environment variables configuration file.
*   `Dockerfile`: For building the Docker image.
*   `pyproject.toml`: Python project configuration and dependencies.
*   `CLAUDE.md`: Detailed project documentation and instructions.
*   `README.md`: This file.

## Troubleshooting

### Common Issues

1. **`DagsterDbtManifestNotFoundError`**: 
   - Make sure you ran `dbt deps` and `dbt parse` in the `cne-dbt-template` directory
   - Check that `cne-dbt-template/target/manifest.json` exists

2. **BigQuery Authentication Errors**:
   - Verify your service account JSON is at `.keys/staging.json`
   - Check that your `.env` file has the correct `BIGQUERY_DATABASE` and `BIGQUERY_ACCOUNT` values
   - Ensure your service account has proper BigQuery permissions

3. **Python Version Compatibility**:
   - Use Python 3.11 or 3.12 (avoid 3.13 due to compatibility issues)
   - Run `python --version` to check your current version

4. **Module Import Errors**:
   - Make sure you installed the project with `uv pip install -e .`
   - Activate the virtual environment before running any commands

## Architecture Overview

This project integrates **Dagster** and **dbt** for modern data orchestration:

- **Dagster** serves as the orchestration layer, providing scheduling, monitoring, and asset management
- **dbt** handles data transformations in BigQuery
- **dbt models** are automatically converted to **Dagster assets** using the `@dbt_assets` decorator
- The integration uses `DbtCliResource` to execute dbt commands through Dagster
- Asset lineage shows dependencies between dbt models in the Dagster UI
