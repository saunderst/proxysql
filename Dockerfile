FROM debian:jessie
RUN apt-get update && apt-get install -y automake cmake make g++ gcc \
  git libmysqlclient-dev libssl-dev bzip2 libtool
COPY proxysql /tmp/proxysql
WORKDIR /tmp/proxysql
RUN make
RUN make -C tools

FROM debian:jessie
RUN apt-get update && apt-get install -y libssl1.0.0 mysql-client
RUN apt-get clean && rm -rf /var/lib/apt/lists/
RUN mkdir -p /var/lib/proxysql
COPY --from=0 /tmp/proxysql/src/proxysql /usr/bin/proxysql
COPY --from=0 /tmp/proxysql/tools/eventslog_reader_sample /usr/bin/eventslog_reader_sample
COPY --from=0 /tmp/proxysql/tools/check_variables.pl /usr/bin/check_variables.pl
COPY proxysql.cnf /etc/proxysql.cnf
COPY my.cnf /root/.my.cnf
COPY run.sh /run.sh
CMD /run.sh
