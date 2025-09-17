# CNE Dagster Template

A comprehensive data engineering template that integrates **Dagster** for orchestration with **dbt** for data transformation, providing a robust foundation for modern data pipelines.

## 🏗️ Architecture Overview

This template consists of three main components:

1. **Dagster Orchestration Layer** (`cne_dagster/`) - Asset-based pipeline orchestration
2. **dbt Transformation Layer** (`cne-dbt-template/`) - SQL-based data transformations  
3. **Custom CLI Tool** - Enhanced dbt workflow management with validation and automation

### Key Features

- ✅ **Dagster + dbt Integration**: Seamless orchestration of dbt models as Dagster assets
- ✅ **Multi-Cloud Support**: BigQuery and Snowflake connectors
- ✅ **Custom CLI**: Enhanced dbt workflows with validation and automation
- ✅ **Data Quality**: Built-in testing with dbt-expectations and Elementary
- ✅ **Code Quality**: Pre-commit hooks, SQL formatting, and validation
- ✅ **Docker Support**: Containerized deployment ready
- ✅ **Task Automation**: Go-task based workflow automation

## 📋 Prerequisites

Before setting up the project, ensure you have:

- **Python 3.12+** (recommended 3.13)
- **Go-task** ([Installation Guide](https://taskfile.dev/installation/))
- **Git** and **GitHub CLI** (optional but recommended)
- **Docker** (for containerized deployment)
- Access to **BigQuery** or **Snowflake** data warehouse

## 🚀 Quick Start

### 1. Environment Setup

Clone the repository and set up your development environment:

```bash
# Clone the repository
git clone <repository-url>
cd cne-dagster-template

# Option A: Automated setup (recommended)
task setup-env

# Option B: Manual setup
# Install uv package manager
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create virtual environment and install dependencies
uv venv
source .venv/bin/activate
uv pip install -e .
```

### 2. Configuration

Copy the environment template and configure your settings:

```bash
cp cne-dbt-template/.env_example cne-dbt-template/.env
```

Edit `.env` with your warehouse connection details:

```bash
# BigQuery Configuration
BIGQUERY_ACCOUNT=your-project-id
BIGQUERY_DATABASE=your-dataset
BIGQUERY_KEYFILE_PATH=path/to/service-account.json
TARGET_NAME=dev

# Organization Settings
ORG_ID=your-org-id
```

### 3. Verify Setup

Test your configuration:

```bash
# Verify environment setup
task test-setup

# Test dbt connection
task dbt:debug

# Launch CLI interface
task cli
```

### 4. Run Dagster

Start the Dagster web interface:

```bash
# Development mode
cd cne_dagster
dagster dev

# Or using Docker
docker build -t cne-dagster-template .
docker run -p 3000:3000 cne-dagster-template
```

Access Dagster UI at `http://localhost:3000`

## 🏗️ Project Structure

```
cne-dagster-template/
├── cne_dagster/                 # Dagster orchestration layer
│   ├── cne_dagster/
│   │   ├── assets.py           # dbt assets definition
│   │   ├── definitions.py      # Dagster definitions
│   │   ├── project.py          # dbt project configuration
│   │   └── schedules.py        # Pipeline schedules
│   └── pyproject.toml          # Dagster dependencies
├── cne-dbt-template/           # dbt transformation layer
│   ├── models/                 # dbt models (staging, marts)
│   ├── macros/                 # Reusable SQL macros
│   ├── tests/                  # Data quality tests
│   ├── cli/                    # Custom CLI tool
│   │   ├── commands/           # CLI command implementations
│   │   ├── utils/              # Utility functions
│   │   └── validate/           # Validation plugins
│   ├── dbt_project.yml         # dbt project configuration
│   └── Taskfile.yml            # Task automation
├── Dockerfile                  # Container configuration
└── pyproject.toml             # Root project dependencies
```

## 💻 Usage

### Dagster Operations

```bash
# Start Dagster development server
cd cne_dagster
dagster dev

# Materialize all assets
dagster asset materialize --select "*"

# Run specific dbt models through Dagster
dagster asset materialize --select "tikal_dbt_dbt_assets"
```

### dbt Operations via CLI

The project includes a custom CLI with enhanced dbt workflows:

```bash
# Launch interactive CLI
task cli

# Available commands in CLI:
create model --name my_model --type staging
create domain --name user_analytics
validate --all
select models --pattern "staging.*"
```

### Direct dbt Commands

```bash
# Navigate to dbt project
cd cne-dbt-template

# Install dbt packages
dbt deps

# Run models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
```

### Task Automation

Common workflows are automated using Go-task:

```bash
# View all available tasks
task --list

# Development tasks
task dbt:run          # Run dbt models
task dbt:test         # Run dbt tests
task dbt:docs         # Generate and serve docs
task validate:all     # Run all validations
task format:sql       # Format SQL files

# CI/CD tasks
task ci:test          # Run CI tests
task ci:lint          # Run linters
task ci:security      # Security checks
```

## 🧪 Data Quality & Testing

### Built-in Testing Framework

- **dbt Tests**: Schema tests, data tests, and custom tests
- **dbt-expectations**: Great Expectations integration for advanced data quality
- **Elementary**: Data observability and monitoring

### Validation Pipeline

The project includes comprehensive validation:

```bash
# Run all validations
task validate:all

# Specific validations
cli_validate --check-model-names
cli_validate --check-sql-style
cli_validate --check-yaml-exists
```

### Pre-commit Hooks

Automated code quality checks:

- **Security**: Private key detection, branch protection
- **SQL**: SQLFluff formatting and linting
- **Python**: Black, isort, flake8, mypy
- **dbt**: Model validation, macro documentation

## 🚀 Deployment

### Docker Deployment

```bash
# Build container
docker build -t cne-dagster-template .

# Run container
docker run -p 3000:3000 \
  -e BIGQUERY_ACCOUNT=your-project \
  -e BIGQUERY_KEYFILE_PATH=/keys/service-account.json \
  -v /path/to/keys:/keys \
  cne-dagster-template
```

### Environment Variables

Key environment variables for deployment:

```bash
# Dagster
DAGSTER_HOME=/opt/dagster/app

# dbt Profile
DBT_PROFILE_PROJECT=your-project
DBT_PROFILE=tikal_dbt
TARGET_NAME=prod

# BigQuery
BIGQUERY_DATABASE=your-dataset
BIGQUERY_KEYFILE_PATH=/path/to/keyfile.json
SOURCE_DATABASE=your-source-db

# Organization
ORG_ID=your-organization-id
```

## 🔧 Configuration

### dbt Configuration

Key configuration in `cne-dbt-template/dbt_project.yml`:

```yaml
name: "tikal_dbt"
profile: "tikal_dbt"

vars:
  organization_id: "{{ env_var('ORG_ID') }}"
  source_database: "SAAS_STAGING"
  enable_separate_db: False

models:
  tikal_dbt:
    +on_schema_change: "sync_all_columns"
```

### Dagster Configuration

Dagster is configured in `cne_dagster/cne_dagster/definitions.py`:

```python
defs = Definitions(
    assets=[tikal_dbt_dbt_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=tikal_dbt_project),
    },
)
```

## 📚 Development Workflows

### Creating New Models

1. **Using CLI** (Recommended):
   ```bash
   task cli
   create model --name user_metrics --type marts
   ```

2. **Manual Creation**:
   ```bash
   # Create model file
   touch cne-dbt-template/models/marts/user_metrics.sql
   
   # Create corresponding YAML
   touch cne-dbt-template/models/marts/user_metrics.yml
   ```

### Model Organization

Follow the medallion architecture:

- **Staging** (`models/*/staging/`): Clean and standardize raw data
- **Marts** (`models/*/marts/`): Business-defined entities for reporting
- **Gold** (`models/*/gold/`): Aggregated, analysis-ready datasets

### Testing New Models

```bash
# Test specific model
dbt test --select user_metrics

# Test with dependencies
dbt test --select +user_metrics+

# Run in Dagster
dagster asset materialize --select "user_metrics"
```

## 🔍 Monitoring & Observability

### Elementary Integration

The project includes Elementary for data observability:

```bash
# Generate Elementary report
dbt run --select elementary

# Serve Elementary UI
elementary monitor --project-dir cne-dbt-template
```

### Dagster Monitoring

- **Asset Lineage**: Visual representation of data dependencies
- **Run History**: Track pipeline execution history
- **Alerts**: Configure alerts for failed runs
- **Metrics**: Monitor asset freshness and quality

## 🤝 Contributing

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Set up pre-commit hooks:
   ```bash
   pre-commit install
   ```
4. Make your changes
5. Run tests and validations:
   ```bash
   task ci:test
   task validate:all
   ```
6. Submit a pull request

### Code Style

- **SQL**: Follow SQLFluff configuration
- **Python**: Black formatting, flake8 linting
- **Documentation**: Update relevant docs for new features

## 📖 Additional Resources

### Documentation

- **dbt**: [dbt Documentation](https://docs.getdbt.com/)
- **Dagster**: [Dagster Documentation](https://docs.dagster.io/)
- **Dagster + dbt**: [Integration Guide](https://docs.dagster.io/integrations/dbt)

### IDE Extensions

- **VS Code**: [dbt Power User](https://marketplace.visualstudio.com/items?itemName=innoverio.vscode-dbt-power-user)
- **IntelliJ**: [dbt Plugin](https://plugins.jetbrains.com/plugin/23789-dbt)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 🆘 Troubleshooting

### Common Issues

1. **dbt Connection Issues**:
   ```bash
   task dbt:debug
   # Check your profiles.yml and environment variables
   ```

2. **Dagster Asset Loading**:
   ```bash
   # Ensure dbt project is parsed
   cd cne-dbt-template && dbt parse
   ```

3. **CLI Not Working**:
   ```bash
   # Reinstall in development mode
   uv pip install -e .
   ```

### Getting Help

- Check the [Issues](../../issues) page for known problems
- Review logs in `cne-dbt-template/logs/dbt.log`
- Use `task --list` to see all available commands
- Run commands with `--help` for detailed usage

---

**Built with ❤️ by the Tikal CNE Team**
