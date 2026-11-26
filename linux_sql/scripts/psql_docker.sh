#!/bin/sh

# Capture CLI arguments
cmd=$1
db_username=$2
dbpassword=$3

# Start docker
# Make sure you understand the double pipe operator
sudo systemctl status docker || sudo systemctl start docker

# Check container status (try the following cmds on terminal)
docker container inspect jrvs-psql
container_status=$?

echo container status is $?

