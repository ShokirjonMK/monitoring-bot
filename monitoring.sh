#!/bin/bash

script_folder=$(dirname $(readlink -f "$0"))
source ${script_folder}/conf.d/init.conf

## Service variables ##
cpu_active_alarm_count=0

init(){
	if [[ ! -d "$LOG_FILE_PATH" ]]; then 
		mkdir -p $LOG_FILE_PATH 
	fi
	if [[ ! -d "$STATE_FILES_DIR" ]]; then
	       	mkdir -p $STATE_FILES_DIR
	else
		rm -f ${STATE_FILES_DIR}/*
       	fi
	touch ${STATE_FILES_DIR}/running
}

source ${script_folder}/workers/cpu
source ${script_folder}/workers/storage

init

while [[ -f ${STATE_FILES_DIR}/running ]]; do
	calculate_cpu_load
	calculate_storage
	sleep $MONITORING_INTERVAL
done
