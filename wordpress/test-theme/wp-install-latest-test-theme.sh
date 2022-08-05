#!/bin/bash -e

clear
echo "============================================"
echo "WordPress Install Script"
echo "============================================"
echo "Theme name: "
read -e theme_name

folder_name="wp_$theme_name"
mkdir -p "$folder_name"

echo "Target Folder: $folder_name"

echo "Database Name: $folder_name"

echo "Database User: $folder_name"

# Change to any format you like. e.g: ${folder_name}@123
dbpass="${folder_name}"
# Or generate a random password
# dbpass=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12 ; echo '')
echo "Database Password: $dbpass"

echo "Are you download file from https://wordpress.org/latest.tar.gz to current folder? (y/n)"
read -e downloaded
if [ "$downloaded" == n ] ; then
echo "Download wordpress..."
wget "https://wordpress.org/latest.tar.gz"
fi

echo "Please enter root user MySQL password!"
echo "It will be use to create a a database with same database, username and password"
echo "Note: password will be hidden when typing"
read -s rootpasswd
mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${folder_name} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -uroot -p${rootpasswd} -e "CREATE USER ${folder_name}@'%' IDENTIFIED BY '${folder_name}';"
mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${folder_name}.* TO '${folder_name}'@'%';"
mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"

echo "============================================"
echo "A robot is now installing latest WordPress for you..."
echo "============================================"
#unzip wordpress
echo "Extract wordpress..."
tar zxf latest.tar.gz -C $folder_name
#change dir to folder name
cd $folder_name
#change dir to wordpress
cd wordpress
#copy file to parent dir
cp -rf . ..
#move back to parent dir
cd ..
#remove files from wordpress folder
rm -R wordpress

echo "Config wp-config.php ..."
# cp wp-config-sample.php wp-config.php
cp wp-config-sample.php wp-config.php
#set database details with perl find and replace
perl -pi -e "s/database_name_here/$folder_name/g" wp-config.php
perl -pi -e "s/username_here/$folder_name/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php
sed -i "s/'DB_CHARSET', 'utf8'/'DB_CHARSET', 'utf8mb4'/" wp-config.php
sed -i "s/'DB_COLLATE', ''/'DB_COLLATE', 'utf8mb4_unicode_ci'/" wp-config.php

#set WP salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

echo "Set FS_METHOD to 'direct', YOU SHOULD DISABLE IT ON SHARED HOSTING FOR SECURITY REASON"
echo "# Should disable on shared host" >> wp-config.php
echo "define('FS_METHOD', 'direct');" >> wp-config.php

#create uploads folder and set permissions
mkdir -p wp-content/uploads
# chmod -R 775 wp-content/uploads
sudo chown -R $USER:www-data .
sudo find . -type d -exec chmod g+s {} \;
sudo chmod -R g+w ./wp-content
sudo chmod -R g+w ./wp-content/themes
sudo chmod -R g+w ./wp-content/plugins

echo "========================="
echo "Installation is complete."
echo "Please config /etc/hosts and add nginx config"
echo "========================="
