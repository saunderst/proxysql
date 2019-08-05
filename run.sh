#!/bin/bash
set -e

if [[ $SHARD_ID = "0" ]] || [[ $SHARD_ID = "m" ]]; then
  export SCHEMA="shopify"
else
  export SCHEMA="shopify_shard_$SHARD_ID"
fi

if [[ $SHARD_ID = "123" ]]; then
  export QUERY_RULES=$',\n{\nrule_id = 3\nactive = 1\nmatch_digest = "SELECT `products`.*, `collects`.`position` AS _sort_value_for_paginator FROM `products` INNER JOIN `collects` ON `collects`.`product_id` = `products`.`id` LEFT JOIN `product_publications` ON `product_publications`.`product_id`"\ndestination_hostgroup=1\n}'
else
  export QUERY_RULES=""
fi

for config in /etc/proxysql.cnf /root/.my.cnf
do
  perl -i -pe 's/\$([A-Z_]+)/$ENV{$1}/g' $config
done

exec proxysql -f --idle-threads
