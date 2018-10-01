FROM ubuntu:16.04
RUN apt-get update && apt-get install -y automake cmake make g++ gcc \
  git libmysqlclient-dev libssl-dev bzip2 libtool
COPY proxysql /tmp/proxysql
WORKDIR /tmp/proxysql
RUN make

FROM ubuntu:16.04
RUN apt-get update && apt-get install -y libssl1.0.0
RUN apt-get clean && rm -rf /var/lib/apt/lists/
RUN mkdir -p /var/lib/proxysql
COPY --from=0 /tmp/proxysql/src/proxysql /usr/bin/proxysql
COPY proxysql.cnf /etc/proxysql.cnf
COPY my.cnf /root/.my.cnf
COPY run.sh /run.sh
CMD /run.sh
