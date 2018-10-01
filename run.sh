#!/bin/bash
set -e

if [[ $SHARD_ID = "0" ]] || [[ $SHARD_ID = "m" ]]; then
  export SCHEMA="shopify"
else
  export SCHEMA="shopify_shard_$SHARD_ID"
fi

for config in /etc/proxysql.cnf /root/.my.cnf
do
  perl -i -pe 's/\$([A-Z_]+)/$ENV{$1}/g' $config
done

exec proxysql -f --idle-threads
