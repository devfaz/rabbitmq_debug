#!/bin/bash

RABBITMQ_ERLANG_COOKIE='secret cookie here'
RABBITMQ_NETWORK='rabbitmq_debug_network'


# setup network
docker network create ${RABBITMQ_NETWORK}

# setup cluster
docker run -d -v $PWD:/tmp/debug --network "${RABBITMQ_NETWORK}"  -e RABBITMQ_ERLANG_COOKIE="${RABBITMQ_ERLANG_COOKIE}" --hostname node1 --name node1 rabbitmq:3-management
docker run -d -v $PWD:/tmp/debug --network "${RABBITMQ_NETWORK}"  -e RABBITMQ_ERLANG_COOKIE="${RABBITMQ_ERLANG_COOKIE}" --hostname node2 --name node2 rabbitmq:3-management
docker run -d -v $PWD:/tmp/debug --network "${RABBITMQ_NETWORK}"  -e RABBITMQ_ERLANG_COOKIE="${RABBITMQ_ERLANG_COOKIE}" --hostname node3 --name node3 rabbitmq:3-management
sleep 10

until docker exec -it node1 rabbitmqctl await_startup
do
    sleep 1
done

docker exec -it node2 rabbitmqctl await_startup
docker exec -it node2 rabbitmqctl stop_app
docker exec -it node2 rabbitmqctl join_cluster rabbit@node1
docker exec -it node2 rabbitmqctl start_app

docker exec -it node3 rabbitmqctl await_startup
docker exec -it node3 rabbitmqctl stop_app
docker exec -it node3 rabbitmqctl join_cluster rabbit@node1
docker exec -it node3 rabbitmqctl start_app

# enable drop_unroutable_metric feature
docker exec -it node1 rabbitmqctl enable_feature_flag drop_unroutable_metric

# setup admin
docker exec -it node1 rabbitmqctl add_user admin administrator
docker exec -it node1 rabbitmqctl set_user_tags admin administrator
docker exec -it node1 rabbitmqctl set_permissions --vhost / admin '.*' '.*' '.*'

# setup user
docker exec -it node1 rabbitmqctl add_user user password
docker exec -it node1 rabbitmqctl set_user_tags user administrator
docker exec -it node1 rabbitmqctl set_permissions --vhost / user '.*' '.*' '.*'

# setup policy
docker exec -it node1 rabbitmqctl set_policy ha '^(?!amq\.).*' '{"ha-mode":"all", "ha-sync-mode": "automatic"}' --priority 10 --apply-to all

