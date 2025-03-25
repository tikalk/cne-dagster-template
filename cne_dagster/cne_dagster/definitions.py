from dagster import Definitions
from dagster_dbt import DbtCliResource
from .assets import tikal_dbt_dbt_assets
from .project import tikal_dbt_project
from .schedules import schedules

defs = Definitions(
    assets=[tikal_dbt_dbt_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=tikal_dbt_project),
    },
)