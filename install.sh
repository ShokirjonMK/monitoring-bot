#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run by root user or as sudoer"
	exit 2
fi

echo "Installing..."

sleep 1

readonly WORK_DIR=$(dirname $(readlink -f "$0"))

source ${WORK_DIR}/conf.d/init.conf

echo "Generating unit file..."

sleep 1

cat > /tmp/${UNIT_NAME}.service <<EOF
[Unit]
Description=Single host monitoring tool
After=network.target

[Service]
Type=simple
ExecStart=${WORK_DIR}/monitoring.sh
ExecStop=-/usr/bin/rm -f ${STATE_FILES_DIR}/running
ExecRestart=-/usr/bin/rm -f ${STATE_FILES_DIR}/running && sleep $MONITORING_INTERVAL && ${WORK_DIR}/monitoring.sh

[Install]
WantedBy=multi-user.target
EOF

mv /tmp/${UNIT_NAME}.service /etc/systemd/system/${UNIT_NAME}.service

echo "Starting ${UNIT_NAME} service..."

systemctl daemon-reload
systemctl enable --now ${UNIT_NAME}.service

sleep 1

echo "Installing has been completed successfully!!!"


