from pathlib import Path

from dagster_dbt import DbtProject

tikal_dbt_project = DbtProject(
    project_dir=Path(__file__).joinpath("..", "..", "..", "cne-dbt-template").resolve(),
    packaged_project_dir=Path(__file__).joinpath("..", "..", "dbt-project").resolve(),
)
tikal_dbt_project.prepare_if_dev()