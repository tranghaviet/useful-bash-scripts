#!/bin/bash

WORK_DIR="/opt/scripts"
TELEGRAM_LIB_PATH="/etc/telegram/telegram-notify"

sudo mkdir -p /etc/telegram
sudo mkdir -p $WORK_DIR
sudo chown -R $USER:$USER $WORK_DIR

wget -qO $TELEGRAM_LIB_PATH https://raw.githubusercontent.com/NicolasBernaerts/debian-scripts/4decf6fe37cf69da9f009796692563bd1f86bb03/telegram/telegram-notify && sleep 2
sudo chmod 755 $TELEGRAM_LIB_PATH

echo "Go to https://t.me/BotFather to create a new bot or choose existing one then get API key"
read -p "Enter YourAPIKey: " YourAPIKey

echo ""

echo "Create a channel then add https://t.me/getidsbot to your channel to get channel ID (include - at the beginning)"
echo "Or you can direct message to the bot to get User ID."
echo "After that remove the bot."
read -p "Enter YourUserOrChannelID: " YourUserOrChannelID

sudo tee /etc/telegram-notify.conf > /dev/null <<EOF
[general]
api-key=$YourAPIKey
user-id=$YourUserOrChannelID
[network]
socks-proxy=
EOF

echo ""

echo "Test it work. You should receive a message with title 'Warning test' in channel/inbox with bot"
$TELEGRAM_LIB_PATH --warning --title "Warning test" --text "Storage almost full"

sleep 3

echo ""

echo "------------------------"
echo "All your paritions"
df -h

echo ""

echo "Set up alert for each partition"
read -p "Enter partition path (e.g /dev/sda1): " PARITION_PATH
read -p "Enter error threshold in % (e.g 95): " ERROR_THRESHOLD
read -p "Enter warning threshold in % (e.g 85. enter > 100 to ignore warning): " WARING_THRESHOLD
read -p "Enter your server name (e.g Website A Hong Kong): " SERVER_NAME

wget -qO $WORK_DIR/storage-warning-telegram.sh https://raw.githubusercontent.com/tranghaviet/useful-bash-scripts/main/linux/telegram/storage-warning-telegram.sh
sed -i "s/YOUR_PARITION_PATH/$PARITION_PATH/g" $WORK_DIR/storage-warning-telegram.sh
sed -i "s/YOUR_ERROR_THRESHOLD/$ERROR_THRESHOLD/g" $WORK_DIR/storage-warning-telegram.sh
sed -i "s/YOUR_WARING_THRESHOLD/$WARING_THRESHOLD/g" $WORK_DIR/storage-warning-telegram.sh
sed -i "s/YOUR_SERVER_NAME/$SERVER_NAME/g" $WORK_DIR/storage-warning-telegram.sh

chmod 700 $WORK_DIR/storage-warning-telegram.sh

echo ""

echo "Set up crontab"
sudo apt install cron -y

crontab -l | { cat; echo "0 * * * * /opt/scripts/storage-warning-telegram.sh >> /dev/null 2>&1"; } | crontab -

sudo service cron restart

echo "DONE"
