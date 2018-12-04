FROM mysql:5.7

COPY ./slave.cnf /etc/mysql/conf.d/mysqld.cnf
COPY ./start-slave.sh /docker-entrypoint-initdb.d/start-slave.sh

ENV MYSQL_ALLOW_EMPTY_PASSWORD=1

RUN chmod 644 /etc/mysql/conf.d/mysqld.cnf
