#!/usr/bin/env bash

# Setup DB Connection String
AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}"
export AIRFLOW__CORE__SQL_ALCHEMY_CONN

AIRFLOW__WEBSERVER__SECRET_KEY="`openssl rand -hex 30`"
export AIRFLOW__WEBSERVER__SECRET_KEY

#DBT_POSTGRESQL_CONN="postgresql+psycopg2://${DBT_POSTGRES_USER}:${DBT_POSTGRES_PASSWORD}@${DBT_POSTGRES_HOST}:${POSTGRES_PORT}/${DBT_POSTGRES_DB}"

cd /dbt && dbt compile
rm -f /airflow/airflow-webserver.pid

sleep 10
airflow db upgrade
sleep 10
airflow connections add 'dbt_postgres_instance_raw_data' --conn-type 'postgres' --conn-login ${DBT_POSTGRES_USER} \
--conn-password ${DBT_POSTGRES_PASSWORD} --conn-host ${DBT_POSTGRES_HOST} --conn-port ${POSTGRES_PORT} --conn-schema ${DBT_POSTGRES_DB}

#airflow connections --add --conn_id 'dbt_postgres_instance_raw_data' --conn_uri $DBT_POSTGRESQL_CONN
airflow users create --email sarvindu.kumar@gmail.com --firstname Sarvindu --lastname Kumar --password admin --role Admin --username admin
airflow scheduler & airflow webserver

