#!/bin/bash -e
# Ref: https://gist.github.com/bgallagh3r/2853221
clear
echo "============================================"
echo "WordPress Install Script"
echo "============================================"
echo "Project name (will use to generate database, password...): "
read -e project_name

# read -p "Parent path [./]:" parent_path
# parent_path=${parent_path:./}
# cd "$parent_path"

echo "Append define('FS_METHOD', 'direct'); to wp-config.php? (y/n)"
echo "DO NOT DO IT ON SHARED HOSTING"
read -e set_fs_method

folder_name="wp_test_$project_name"
dbname="wp_test_$project_name"
dbuser="wp_test_$project_name"

# Change to any format you like. e.g: ${project_name}@123
dbpass="wp_test_${project_name}"
# Or generate a random password
# dbpass=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12 ; echo '')

echo "Target Folder: $project_name"

echo "Database Name: $project_name"

echo "Database User: $project_name"

echo "Database Password: $dbpass"
# or get from input
# read -p "Use password '$dbpass'?" new_dbpass
# dbpass=${new_dbpass:-${dbpass}}

echo "Run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
echo "============================================"
echo "A robot is now installing latest WordPress for you."
echo "============================================"
#download wordpress
curl -O https://wordpress.org/latest.tar.gz
#unzip wordpress
tar -zxvf latest.tar.gz -C $project_name
#change dir to wordpress
cd $project_name
#change dir to wordpress
cd wordpress
#copy file to parent dir
cp -rf . ..
#move back to parent dir
cd ..
#remove files from wordpress folder
rm -R wordpress
#create wp config
cp wp-config-sample.php wp-config.php
#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php

#set WP salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

if [ "$set_fs_method" == y ] ; then
echo "\ndefine('FS_METHOD', 'direct');" >> wp-config.php
fi

#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 775 wp-content/uploads
echo "Remove wordpress original file: latest.tar.gz"

#remove zip file
rm ../latest.tar.gz

echo "========================="
echo "Installation is complete."
echo "========================="
fi
