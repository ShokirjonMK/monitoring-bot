#!/bin/bash
echo "mysql db backup..."

now=$(date +%Y%m%d-%H:%M:%S)
filename=$1
backupfilename=$1-$now

REPO_DIR=/home/perfect/sites/tpu-qabul-yii
DOCKERFILE_API=$REPO_DIR/docker-compose.yml

docker compose -f $DOCKERFILE_API exec mysql mysqldump -uroot -pmkperfectQbull tpuqabuul > /home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.sql
zip -r /home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.zip /home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.sql
rm /home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.sql

# // Telegram bot o'zgaruvchilari
API_TOKEN="7336740917:AAFVLagC3mqDwtr8hab6nac7N7vUotJgL0Y"
GROUP_ID="-4267019060"

CHAT_ID="813225336"

# // Faylni gruhga jo'natish
curl -F chat_id="$GROUP_ID" -F document=@"/home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.zip" https://api.telegram.org/bot$API_TOKEN/sendDocument

# // Faylni chatga jo'natish
curl -F chat_id="$CHAT_ID" -F document=@"/home/perfect/mk_backup/qabul_mysql/qabul_mysql_$backupfilename.zip" https://api.telegram.org/bot$API_TOKEN/sendDocument


# // cron settings
# 0 2 * * * * /home/perfect/mk_backup/mk_backup.sh > /home/perfect/mk_backup/log/bot_cron_log.log 2>&1