#!/bin/bash

init()
{
    docker run -itd \
	--name postgresql \
	-p 5432:5432 \
	--env POSTGRES_PASSWORD='12345678' \
	--env POSTGRES_USER='postgres' \
	--env POSTGRES_DB='postgres' \
	postgres:12
}

run()
{
    docker start postgresql
}

stop()
{
    docker kill postgresql
}

clean()
{
    docker rm postgresql -f
}

migrate()
{
    docker run --rm \
	-v /${PWD}/flyway/sql:/flyway/sql \
	-v /${PWD}/flyway/conf:/flyway/conf \
	--network="host" \
	flyway/flyway migrate
}

attach()
{
    docker exec -it postgresql bash -c "psql -U postgres"
}

if [ $1 == "init" ]; then
    init
fi

if [ $1 == "run" ]; then
    run
fi

if [ $1 == "stop" ]; then
    stop
fi

if [ $1 == "clean" ]; then
    clean
fi

if [ $1 == "migrate" ]; then
    migrate
fi

if [ $1 == "attach" ]; then
    attach
fi