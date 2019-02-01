Section: misc
Priority: optional
Homepage: http://www.proxysql.com
Standards-Version: 3.9.2

Package: proxysql
Version: 1.4.14
Maintainer: Rene Cannao <rene.cannao@gmail.com>
Architecture: amd64
# Changelog: CHANGELOG.md
# Readme: README.md
Files: proxysql /usr/bin/
 etc/proxysql.cnf /
 etc/init.d/proxysql /
 tools/proxysql_galera_checker.sh /usr/share/proxysql/
 tools/proxysql_galera_writer.pl /usr/share/proxysql/
Description: High performance MySQL proxy
 ProxySQL is a fast, reliable MySQL proxy with advanced runtime configuration management (virtually no configuration change requires a restart). 
 .
 It features query routing, query caching, query rewriting (for queries generated by ORMs, for example) and is most of the time a drop-in replacement for mysqld from the point of view of the application. It can be configured and remote controlled through an SQL-compatible admin interface.
File: postinst
 #!/bin/sh -e
 if [ ! -d /var/lib/proxysql ]; then mkdir /var/lib/proxysql ; fi
 update-rc.d proxysql defaults
 chmod 600 /etc/proxysql.cnf
