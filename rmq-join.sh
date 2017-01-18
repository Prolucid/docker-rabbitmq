#!/bin/bash

sleep 30

if [ "$RMQ_JOIN_CLUSTER" == "true" ]
then
   rabbitmqctl stop_app
   rabbitmqctl join_cluster rabbit@$RABBITMQ_CLUSTER_SEED
   rabbitmqctl star_app
fi
