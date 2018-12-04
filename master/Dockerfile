FROM mysql:5.7

COPY ./master.cnf /etc/mysql/conf.d/my.cnf

ENV MYSQL_ALLOW_EMPTY_PASSWORD=1

RUN chmod 644 /etc/mysql/conf.d/my.cnf
