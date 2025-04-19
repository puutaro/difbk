#!/bin/bash


echo_target_merge_list_in_con_sch(){
	fd -IH -t d . ${BUCK_UP_DIR_PATH} \
		--max-depth 5 \
	| rga "${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}[/]*$" \
	| sort -r
}