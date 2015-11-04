FROM postgres:9.5

MAINTAINER Mentat Labs Ltd "admin@mentat-labs.com"

ADD sql/*.sql /docker-entrypoint-initdb.d/

ENV POSTGRES_DB fpdb
ENV POSTGRES_USER fpuser
ENV POSTGRES_PASSWORD fppass
