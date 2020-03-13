# ProxySQL

[![Build status](https://badge.buildkite.com/40916cee2d2f3191b7bb772ad9e0d779c66273d4b1089077b4.svg)](https://buildkite.com/shopify/shopify-proxysql-production-builder)

ProxySQL is the proxy that powers the layer between Shopify Core and MySQL.

It's deployed, alongside [Taiji][], as part of [shopify-core-datastores](https://github.com/Shopify/shopify-core-datastores).

[Taiji]: https://github.com/Shopify/taiji

# Building on MacOS

1. Navigate to `proxysql`, run `make` or `make debug` if you're planning to attach with a debugger.

2. `src/proxysql` will be the compiled binary.

## Hacking locally

1. Install [Docker for Mac](https://docs.docker.com/docker-for-mac/install/)
2. Build ProxySQL (see steps above)
3. `cd hacking/ && docker-compose up`
4. `hacking/setup-replication` to configure replication of MySQLs running in Docker
5. `proxysql/src/proxysql --initial --debug 5 -f -c hacking/proxysql.cfg`
  * `--debug 5` is log level
  * `hacking/proxysql.cfg` is the config that should work with docker-compose services, but feel free to tweak that!
6. ProxySQL should be ready to accept connections. Try it with `mysql -u root -P 3306 -h 127.0.0.1`

# How to :tophat:

If you have changes on a fork you want to test:

Check out https://github.com/Shopify/shopify-proxysql and add the upstream as a remote and fetch:

    git remote add upstream git@github.com:sysown/proxysql.git
    git fetch upstream

Then put yourself on a branch

    git checkout -b better-parsing

Then cherry pick your commit:

    git cherry-pick ef071ee3f98d252605d361266503556c18f7e81a

Then push it to a branch

    git push --set-upstream origin better-parsing

Once it’s on your branch, you can watch for the container to finish building here:

https://buildkite.com/shopify/shopify-proxysql-production-builder

It’s going to get pushed to GCR and be tagged with the SHA of whatever your branch is on:

    git rev-parse HEAD

Then you can edit the existing staging deployment and change it to use your SHA:

    kubectl --context tier4 --namespace shopify-datastores-staging edit deployment proxysql-pod998

Find the `image:` line for ProxySQL and swap it to:

    gcr.io/shopify-docker-images/apps/production/shopify-proxysql:<the sha output from git-rev-parse>

# How to roll it out, slowly

`deploy.rb` in the https://github.com/Shopify/shopify-core-datastores
repository has a `BETA_PROXYSQL_VERSION` and `BETA_SHARDS` -- you can update
the former to any git revision in this repository and the latter to include
(eventually) all pods when rolling out a new version.
