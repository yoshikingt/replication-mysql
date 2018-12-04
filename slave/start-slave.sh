#!/bin/sh

# Master の起動待機
while ! mysqladmin ping -h mysql-master --port 3306 --silent; do
    sleep 1
done

# Master をロック
mysql -u root -h mysql-master --port 3306 -e "RESET MASTER;"
mysql -u root -h mysql-master --port 3306 -e "FLUSH TABLES WITH READ LOCK;"

# Master を dump
mysqldump -uroot -h mysql-master --port 3306 --all-databases --master-data --single-transaction --flush-logs --events > /tmp/master_dump.sql

# dump ファイルを Slave に import
mysql -u root -e "STOP SLAVE;"
mysql -u root < /tmp/master_dump.sql

# Master に繋いで bin-log のファイル名とポジションを取得
log_file=`mysql -u root -h mysql-master --port 3306 -e "SHOW MASTER STATUS\G" | grep File: | awk '{print $2}'`
pos=`mysql -u root -h mysql-master --port 3306 -e "SHOW MASTER STATUS\G" | grep Position: | awk '{print $2}'`

# Slave 開始
mysql -u root -e "RESET SLAVE";
mysql -u root -e "CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_PORT=3306, MASTER_USER='root', MASTER_PASSWORD='', MASTER_LOG_FILE='${log_file}', MASTER_LOG_POS=${pos};"
mysql -u root -e "START SLAVE"

# Master をアンロック
mysql -u root -h mysql-master --port 3306 -e "UNLOCK TABLES;"
