# Postgres & Flyway & Docker
Runs a Postgres DB accessible on localhost:5432

Only Dependency is Docker

Found myself using this same pattern in team projects to quickly get a database running for local dev purposes so figured it might be useful to some other devs.

The Makefile is the original component, comments should explain what the commands do.

`Database.sh` was created for a Windows friendlier version, you'll still need a terminal that supports `PWD`. I haven't used it beyond testing basic functionallity but teammates have been using it without issue.

## Example
Shows normal usage of each command, notice that `make stop` is data safe, `make clean` is not and requires a `make init` afterwards.

```
20:17:47 hunterlogan postgres-flyway-docker$ make init
docker run -itd \
	--name postgresql \
	-p 5432:5432 \
	--env POSTGRES_PASSWORD='12345678' \
	--env POSTGRES_USER='postgres' \
	--env POSTGRES_DB='postgres' \
	postgres:12
5bdfdd08e2d3c9339a068dfad3101518e7dbb2f5851f4cb0c920fb1696ea1f30

20:17:49 hunterlogan postgres-flyway-docker$ make migrate
docker run --rm \
	-v /Users/hunterlogan/Documents/dev/postgres-flyway-docker/flyway/sql:/flyway/sql \
	-v /Users/hunterlogan/Documents/dev/postgres-flyway-docker/flyway/conf:/flyway/conf \
	--network="host" \
	flyway/flyway migrate
Flyway Community Edition 6.2.2 by Redgate
Database: jdbc:postgresql://localhost:5432/postgres (PostgreSQL 12.0)
Successfully validated 2 migrations (execution time 00:00.040s)
Creating Schema History table "public"."flyway_schema_history" ...
Current version of schema "public": << Empty Schema >>
Migrating schema "public" to version 1 - Create person table
Migrating schema "public" to version 2 - Modify person table
Successfully applied 2 migrations to schema "public" (execution time 00:00.238s)

20:17:56 hunterlogan postgres-flyway-docker$ make stop
docker kill postgresql
postgresql

20:18:15 hunterlogan postgres-flyway-docker$ make run
docker start postgresql
postgresql

20:18:22 hunterlogan postgres-flyway-docker$ make migrate
docker run --rm \
	-v /Users/hunterlogan/Documents/dev/postgres-flyway-docker/flyway/sql:/flyway/sql \
	-v /Users/hunterlogan/Documents/dev/postgres-flyway-docker/flyway/conf:/flyway/conf \
	--network="host" \
	flyway/flyway migrate
Flyway Community Edition 6.2.2 by Redgate
Database: jdbc:postgresql://localhost:5432/postgres (PostgreSQL 12.0)
Successfully validated 2 migrations (execution time 00:00.045s)
Current version of schema "public": 2
Schema "public" is up to date. No migration necessary.

20:18:33 hunterlogan postgres-flyway-docker$ make attach
docker exec -it postgresql bash -c "psql -U postgres"
psql (12.0 (Debian 12.0-2.pgdg100+1))
Type "help" for help.

postgres=# select * from person;
 id | name  | iq
----+-------+-----
  2 | Rick  | 150
  1 | Morty |  10
(2 rows)

postgres=# exit

20:19:06 hunterlogan postgres-flyway-docker$ make clean
docker rm postgresql -f
postgresql
```