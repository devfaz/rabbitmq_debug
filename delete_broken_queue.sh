#!/bin/bash

test -n "$1" || exit 1
QUEUE=$1
echo $QUEUE

rabbitmqctl eval '{ok, Q} = rabbit_amqqueue:lookup(rabbit_misc:r(<<"/">>, queue, <<"'${QUEUE}'">>)), rabbit_amqqueue:delete_crashed(Q).'


