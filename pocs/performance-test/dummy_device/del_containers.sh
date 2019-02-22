#!/bin/bash

for container in `docker ps -a | grep dummy_device | awk '{print $1}'`;
do
    docker rm --force $container >/dev/null
done

echo "deleted"
