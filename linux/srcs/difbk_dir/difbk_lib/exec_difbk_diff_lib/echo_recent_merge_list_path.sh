#!/bin/bash


echo_recent_merge_list_path(){
	local merge_list_depth=6
	fd . \
		"${BUCK_UP_DIR_PATH}" -d ${merge_list_depth} \
	| rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" \
	| tail -n 1
}