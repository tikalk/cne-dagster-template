FROM python:3.11.3-slim

ENV DAGSTER_HOME=/opt/dagster/app


RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential curl && \
    pip install --no-cache-dir --upgrade pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install dagster dagit dagster-dbt dagster-webserver dbt-bigquery dbt-core
# Add the rest of the app files
ADD . $DAGSTER_HOME/cne_dagster

ENV DBT_PROFILE_PROJECT=tdw-staging \
    DBT_PROFILE=tikal_dbt \
    BIGQUERY_DATABASE=chaimt_dwh \
    DATASET_PREFIX=chaimt_dwh \
    TARGET_NAME=dev \
    BIGQUERY_KEYFILE_PATH=.keys/staging.json \ 
    SOURCE_DATABASE=dwh-dev-414206 \
    BIGQUERY_ACCOUNT=dwh-dev-414206 


RUN cd $DAGSTER_HOME/cne_dagster/cne-dbt-template && dbt deps --quiet && dbt parse --quiet

WORKDIR $DAGSTER_HOME/cne_dagster/cne_dagster


# Set environment variable for production
ENV PYTHONUNBUFFERED=1

# Command to run the Dagster app with uvicorn


EXPOSE 3000

CMD ["dagster", "dev", "-h", "0.0.0.0", "-p", "3000"]