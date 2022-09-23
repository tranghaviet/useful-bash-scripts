#!/bin/bash

# see usage: df -h or lsblk -l
# change the /dev/sda partition if need
# threshold in percentage

PARITION_PATH="YOUR_PARITION_PATH"

CURRENT=$(df | grep "$PARITION_PATH" -m 1 | awk '{print $5}' | sed 's/%//g')

ERROR_THRESHOLD=YOUR_ERROR_THRESHOLD # <---- change this
WARING_THRESHOLD=YOUR_WARING_THRESHOLD # <---- change this

DISK_INFO=$(df -h | grep "Filesystem\|$PARITION_PATH" -m 2)

SERVER_NAME="YOUR_SERVER_NAME"

if [ "$CURRENT" -gt "$ERROR_THRESHOLD" ] ; then
    . /etc/telegram/telegram-notify --error --title "[Error] $SERVER_NAME partition \$PARITION_PATH reach \$CURRENT%" --html "\`\`\`\n$DISK_INFO\n\`\`\`\nPlease consider scale the server"
elif [ "$CURRENT" -gt "$WARING_THRESHOLD" ] ; then
    . /etc/telegram/telegram-notify --waring --title "[Warning] $SERVER_NAME partition \$PARITION_PATH reach \$CURRENT%" --html "\`\`\`\n$DISK_INFO\n\`\`\`"
fi
