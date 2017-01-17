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
  curl -O http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server_3.6.6-1_all.deb && \
  curl -O https://bintray.com/rabbitmq/community-plugins/download_file?file_path=rabbitmq_web_mqtt-3.6.x-14dae543.ez && \
  dpkg -i --ignore-depends=erlang-nox rabbitmq-server_3.6.6-1_all.deb && \
  mv rabbitmq_web_mqtt-3.6.x-14dae543.ez /plugins && \
  rabbitmq-plugins enable rabbitmq_management && \
  rabbitmq-plugins enable rabbitmq_mqtt && \
  rabbitmq-plugins enable rabbitmq_web_mqtt

# Define environment variables.
ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia
ENV RMQ_JOIN_CLUSTER false

# Add rmq join cluster script
ADD rmq-join.sh /app/rmq-join.sh

#Add startup script
RUN mkdir -p /etc/service/rabbitmq
ADD start-rmq.sh /etc/service/rabbitmq/run
RUN chmod +x /etc/service/rabbitmq/run

# Expose ports.
EXPOSE 5672
EXPOSE 15672
EXPOSE 4369
EXPOSE 14369
EXPOSE 44001

# Define Volumes
VOLUME ["/data/log", "/data/mnesia", "/etc/rabbitmq"]
