from pathlib import Path
from dagster_dbt import DbtProject

# Path to the dbt project (submodule)
tikal_dbt_project = DbtProject(
    project_dir=Path(__file__).joinpath("..", "..", "..", "cne-dbt-template").resolve(),
    packaged_project_dir=Path(__file__).joinpath("..", "..", "dbt-project").resolve(),
)

# Prepare the project for development (builds manifest if needed)
tikal_dbt_project.prepare_if_dev()