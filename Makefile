.PHONY: init, run, stop, migrate, clean, attach

# Build & run the container, DB can take a little while to start up
init:
	docker run -itd \
	--name postgresql \
	-p 5432:5432 \
	--env POSTGRES_PASSWORD='12345678' \
	--env POSTGRES_USER='postgres' \
	--env POSTGRES_DB='postgres' \
	postgres:12

# Run an already built container (e.g. a container you stopped instead of cleaned)
run:
	docker start postgresql

# Stops the container running the db (not destructive to changes made to DB)
stop:
	docker kill postgresql

# Kills and destroys the container created with init (destructive)
# Make run will not work after this command until make init is run again
clean:
	docker rm postgresql -f

# Runs migrations on DB using flyway
migrate:
	docker run --rm \
	-v ${PWD}/flyway/sql:/flyway/sql \
	-v ${PWD}/flyway/conf:/flyway/conf \
	--network="host" \
	flyway/flyway migrate

# Attaches a terminal to DB
attach:
	docker exec -it postgresql bash -c "psql -U postgres"
