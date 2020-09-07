#!/bin/bash

RABBITMQ_NETWORK='rabbitmq_debug_network'


docker run -d -it -v $PWD:/opt --network "${RABBITMQ_NETWORK}" --name check python bash -i

docker exec -it check /opt/run_check_cluster
