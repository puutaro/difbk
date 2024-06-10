#!/bin/bash


echo_recent_backup_datetime_directory_path(){
	local merge_list_depth=4
	fd . \
		-t d \
		"${BUCK_UP_DIR_PATH}" -d ${merge_list_depth} \
	| rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}" \
	| sort \
	| tail -n 1 \
	| rga -o "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}"
}