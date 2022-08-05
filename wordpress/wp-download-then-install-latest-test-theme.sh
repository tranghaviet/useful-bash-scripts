#!/bin/bash -e
# Ref: https://gist.github.com/bgallagh3r/2853221
clear
echo "============================================"
echo "WordPress Install Script"
echo "============================================"
echo "Theme name: "
read -e theme_name


folder_name="wp_test_$theme_name"
echo "Target Folder: $folder_name"

echo "Database Name: $folder_name"

echo "Database User: $folder_name"

# Change to any format you like. e.g: ${folder_name}@123
dbpass="${folder_name}"
# Or generate a random password
# dbpass=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12 ; echo '')
echo "Database Password: $dbpass"

echo "Run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
echo "============================================"
echo "A robot is now installing latest WordPress for you."
echo "============================================"
#download wordpress
wget https://wordpress.org/latest.tar.gz
#unzip wordpress
tar -zxvf latest.tar.gz -C $folder_name
#change dir to wordpress
cd $folder_name
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

echo "\ndefine('FS_METHOD', 'direct');" >> wp-config.php

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
