#!/bin/bash



make_target_list_and_path_when_no_merge_list_path(){
	TARGET_MERGE_LIST=$(\
		fd -IH -t d . ${BUCK_UP_DIR_PATH} -d 5 \
		| rga "[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}" \
		| sort -r\
	)
}