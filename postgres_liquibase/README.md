## How to run Liquibase against Postgres DB

1. Run the `init-db-user.sh` script to create necessary role/permisions for Liquibase.
   PSQL script expects the admin password to be in the `PGPASSWORD` environment variable.

2. Execute `make update` to run Liquibase update.
