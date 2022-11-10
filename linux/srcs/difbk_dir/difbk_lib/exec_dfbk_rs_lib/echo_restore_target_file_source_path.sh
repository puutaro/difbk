#!/bin/bash


echo_restore_target_file_source_path(){
	local file_path_with_merge_or_gip="${1}"
	local filtered_path_by_grep=$(\
		echo "${file_path_with_merge_or_gip}" \
			| rga \
				-e "^../${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}/${TARGET_DIR_NAME}" \
				-e "^${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}/${TARGET_DIR_NAME}"\
		)
	test -e "${filtered_path_by_grep}" \
		&& echo "${filtered_path_by_grep}" \
		|| e=$?
}