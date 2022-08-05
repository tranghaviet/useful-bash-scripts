#!/bin/bash

echo "Create a utf8mb4 database with same database, username and password: "
echo "Database name: "
read -e dbname

echo "Please enter root user MySQL password!"
echo "Note: password will be hidden when typing"
read -s rootpasswd
mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${dbname} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -uroot -p${rootpasswd} -e "CREATE USER ${dbname}@'%' IDENTIFIED BY '${dbname}';"
mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbname}'@'%';"
mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
