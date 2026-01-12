FROM postgres:15-alpine

LABEL maintainer="mihaela.schibinschi@vodafone.com"
LABEL description="Task Manager PostgreSQL Database"

COPY init.sql /docker-entrypoint-initdb.d/

# Set default environment variables
ENV POSTGRES_DB=taskdb
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres

EXPOSE 5432

HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD pg_isready -U postgres || exit 1