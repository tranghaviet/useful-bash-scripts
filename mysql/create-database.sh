#!/bin/bash
# Ref: https://raw.githubusercontent.com/saadismail/useful-bash-scripts/master/db.sh

# With some modifies
# Tested on MariaDB 10.5.16 on Ubuntu 18

echo "Please enter root user MySQL password!"
echo "Note: password will be hidden when typing"
read -s rootpasswd

echo "Please enter the NAME of the new MySQL database!"
read dbname

read -p "Please enter the MySQL database CHARACTER SET [utf8mb4]" charset
charset=${charset:-utf8mb4}

read -p "Please enter the MySQL database COLLATION [utf8mb4_unicode_ci]:" collation
collation=${collation:-utf8mb4_unicode_ci}

echo "Creating new MySQL database..."
mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${dbname} CHARACTER SET ${charset} COLLATE ${collation};"

echo "Database successfully created!"
echo "Showing existing databases..."
mysql -uroot -p${rootpasswd} -e "show databases;"

echo "Create a new user for the database (y/n)?"
read create_new_user

if [[ "$create_new_user" == "y" ]]; then
  echo ""
  read -p "Please enter the NAME of the new MySQL database user [${dbname}_user]:" username
  username=${username:-${dbname}_user}

  echo "Please enter the PASSWORD for the new MySQL database user!"
  echo "Note: password will be hidden when typing"
  read -s userpass

  read -p "Enter user IP (leave % for any) [%]:" ip
  ip=${ip:-%}
  echo "Creating new user..."
  mysql -uroot -p${rootpasswd} -e "CREATE USER ${username}@'${ip}' IDENTIFIED BY '${userpass}';"
  echo "User successfully created!"
else
  echo "Enter username will be granted to the database:"
  read username

  read -p "Enter user IP (leave % for any) [%]:" ip
  ip=${ip:-%}
fi

echo ""
echo "Granting ALL privileges on ${dbname} to ${username}!"
mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'${ip}';"
mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"

echo "You're good now :)"
exit
