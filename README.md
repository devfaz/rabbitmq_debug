
# ./run

will just 

* start some docker containers
* build a cluster
* configure users
* generate some load
* kill a node (container)
* check if broken queues exist

created to allow rabbitmq list to (hopefully) debug the issue.

# check_rabbitmq_unroutable_msg

to use check_rabbitmq_unroutable_msg

* run check_rabbitmq_unroutable_msg for the first time, this will setup some queues, bindings, ...
* create an fanout-exchange "unroutable"
* create a binding from unroutable-exchange to unroutable-queue
* change your policy to configure an "alternate exchange" => "unroutable"
* enable the "unroutable msg counter" feature in rabbitmq

check_rabbitmq_unroutable_msg will now trigger an alert if:

* the unroutable msg counter increases
* msgs got placed in "unroutable"

to fix detected errors

```
    ERROR:root:dropped msg in 10.77.16.106:41036 -> 10.78.22.11:5672 (1) 'neutron'
```

* run wip-detect-broken-bindings, write output into file
* execute the output-file (contains bash-cli-cmds)

```
    ERROR:root:Exchange: openstack, RoutingKey: cinder-scheduler could not be routed
```

* open your rabbitmq-mngt-webgui
* navigate to the "openstack" exchange
* click on the queue using the "cinder-scheduler"-routing-key
* click on "delete queue"



