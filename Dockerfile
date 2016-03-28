FROM phusion/baseimage
MAINTAINER Daniel Covello
ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Install RabbitMQ Install dependencies
RUN apt-get update && apt-get install -y wget curl build-essential libssl-dev ncurses-dev python2.7 m4

# Install Erlang and RabbitMQ
RUN  mkdir /erlang && \
  cd /erlang && \
  curl -O http://erlang.org/download/otp_src_17.5.tar.gz && \
  sudo tar xzf otp_src_17.5.tar.gz && \
  cd otp_src_17.5 && \
  export ERL_TOP=`pwd` && \
  ./configure --prefix=/erlang/opt_srv_17.5 --enable-hipe --bindir=/usr/bin --with-ssl && \
  make && \
  make install && \
  cd /tmp && \
  curl -O http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.6/rabbitmq-server_3.5.6-1_all.deb && \
  dpkg -i --ignore-depends=erlang-nox rabbitmq-server_3.5.6-1_all.deb && \
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
