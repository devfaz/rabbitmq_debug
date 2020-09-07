#!/bin/bash

RABBITMQ_NETWORK='rabbitmq_debug_network'

for ID in $( seq 1 $( nproc ) )
do
    NAME="rpc_floodd${ID}"
    docker run -it -d -v $PWD:/opt --network "${RABBITMQ_NETWORK}" --hostname ${NAME} --name ${NAME} python /opt/run_rpc_floodd
done

for ID in $( seq 1 75 )
do
    NAME="rpc_flood_client${ID}"
    docker run -it -d -v $PWD:/opt --network "${RABBITMQ_NETWORK}" --hostname ${NAME} --name ${NAME} python /opt/run_rpc_flood_client
done

