FROM ubuntu:16.04

RUN apt-get update && apt-get install -y automake cmake make g++ gcc \
  git libmysqlclient-dev libssl-dev bzip2 libtool \
  && apt-get clean && rm -rf /var/lib/apt/lists/

COPY proxysql /tmp/proxysql
WORKDIR /tmp/proxysql

RUN make
