#!/bin/sh

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# User switch case to handle create|stop|start options
case $cmd in
  create)
      # Check # of CLI arguments
    if [ $# -lt 3 ]; then
      echo 'Create requires username and password'
      exit 1
    fi

    docker container inspect jrvs-psql
    container_status=$?

    # Check if the container is already created
    if [ $container_status -eq 0 ]; then
      echo 'Container already exists'
      exit 1
    fi

  sudo systemctl status docker || sudo systemctl start docker
    container_status=$?

  # get latest postgres image
  docker pull postgres

  docker run --name jrvs-psql -e POSTGRES_PASSWORD=$PGPASSWORD -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine

  docker volume create pgdata #WHEN SHOULD DOCKER RUN?

  echo 'Container created!'

  exit $?
  ;;

  start|stop)
  echo "checking if the container jrvs-psql is created or not:"
    docker container ls -a -f name=jrvs-psql
    container_status=$?

  echo "Starting/stop the container:"
    docker container $cmd jrvs-psql
    container_status=$?

  if [ $container_status -eq  1 ] && [ $cmd == 'start' ]; then
     echo "Create a container!"
     exit 1
  fi


  echo "Checking container status:"
  docker container inspect jrvs-psql
    #container_status=$?

    #if [ $container_status -eq 0 ]; then
     # echo "Sucessful"
    #fi

    #if [ $cmd == 'stop' ]; then
     # docker container rm jrvs-psql
      #echo jrvs-psql container stop and removed
    #fi
    ;;

  *)
	echo 'Illegal command'
	echo 'Commands: start|stop|create'
	exit 1
	;;
esac

