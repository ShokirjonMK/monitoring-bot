#!/bin/bash
echo "mysql db backup..."
current_datetime=$(date '+%Y-%m-%d %H:%M:%S')

now=$(date +%Y%m%d-%H:%M:%S)
filename=$1
backupfilename=tpu_qabul_$current_datetime

REPO_DIR=/home/perfect/sites/tpu-qabul-yii
DOCKERFILE_API=$REPO_DIR/docker-compose.yml

docker compose -f $DOCKERFILE_API exec mysql mysqldump -uroot -pmkperfectQbull tpuqabuul > /home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.sql
zip -r /home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.zip /home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.sql
rm /home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.sql

# // Telegram bot o'zgaruvchilari
API_TOKEN="7336740917:AAFVLagC3mqDwtr8hab6nac7N7vUotJgL0Y"
GROUP_ID="-4267019060"

CHAT_ID="813225336"
# Construct the message
MESSAGE="This is qabul project's MySQL backup file on $current_datetime"
# // Faylni gruhga jo'natish
curl -F chat_id="$GROUP_ID" -F document=@"/home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.zip" -F caption="$MESSAGE" https://api.telegram.org/bot$API_TOKEN/sendDocument

# // Faylni chatga jo'natish
curl -F chat_id="$CHAT_ID" -F document=@"/home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.zip" https://api.telegram.org/bot$API_TOKEN/sendDocument


# // cron settings
# 0 2 * * * * /home/perfect/mk_backup/mk_backup.sh > /home/perfect/mk_backup/log/bot_cron_log.log 2>&1