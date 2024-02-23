#!/bin/sh

service mysql start;

sleep 10

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MDB_ROOT_PASSWORD}';"

mysql -uroot -p"${MDB_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MDB_DATABASE}\`;"

mysql -uroot -p"${MDB_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${MDB_USER}\`@'%' IDENTIFIED BY '${MDB_PASSWORD}';"

mysql -uroot -p"${MDB_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MDB_DATABASE}\`.* TO \`${MDB_USER}\`@'%' IDENTIFIED BY '${MDB_PASSWORD}';"

mysql -uroot -p"${MDB_ROOT_PASSWORD}" -e "DROP USER IF EXISTS ''@'localhost';"

mysql -uroot -p"${MDB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p$MDB_ROOT_PASSWORD shutdown

exec mysqld_safe
