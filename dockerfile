FROM python:3.8
RUN pip install wtforms==2.3.3 && \
    pip install 'apache-airflow[postgres]==2.2.3' && \
    pip install dbt-core && \
    pip install dbt-postgres && \
    pip install SQLAlchemy

RUN mkdir /project
COPY scripts_airflow/ /project/scripts/

RUN chmod +x /project/scripts/init.sh
ENTRYPOINT [ "/project/scripts/init.sh" ]
