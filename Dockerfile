FROM phusion/baseimage
MAINTAINER Daniel Covello
ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Install RabbitMQ Install dependencies
RUN apt-get update && apt-get install -y wget

# Install RabbitMQ.
RUN \
  wget -qO - https://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add - && \
  echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y rabbitmq-server supervisor&& \
  rm -rf /var/lib/apt/lists/* && \
  rabbitmq-plugins enable rabbitmq_management && \
  rabbitmq-plugins enable rabbitmq_mqtt

# Define environment variables.
ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia

# Expose ports.
EXPOSE 5672
EXPOSE 15672
EXPOSE 4369
EXPOSE 44001

# Expose MQTT Ports
EXPOSE 8883
EXPOSE 1883

# Define Volumes
VOLUME ["/data/log", "/data/mnesia"]
