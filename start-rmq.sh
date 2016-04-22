#!/bin/bash

echo $ERLANG_COOKIE > /var/lib/rabbitmq/.erlang.cookie
chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
chmod 600 /var/lib/rabbitmq/.erlang.cookie

ulimit -n 102400

chown -R rabbitmq:rabbitmq /data

sleep 10

RMQ_HOSTNAME=`hostname`

sh /app/rmq-join.sh > /dev/null & 2>&1
exec /usr/sbin/rabbitmq-server
