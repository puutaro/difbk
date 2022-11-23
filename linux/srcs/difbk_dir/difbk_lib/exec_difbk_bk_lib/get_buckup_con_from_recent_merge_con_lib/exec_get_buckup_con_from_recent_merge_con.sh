#!/bin/bash


exec_get_buckup_con_from_recent_merge_con(){
	local merge_list_file_path="$(\
		echo_merge_list_file_path \
	)"

	case "${merge_list_file_path}" in 
		"") echo ""
			return
	;; esac

	if [ -e "${merge_list_file_path}" ];then 
		zcat "${merge_list_file_path}" \
			| sed '/^$/d'
	fi
}


echo_merge_list_file_path(){
	if [ -e "${BUCK_UP_DIR_PATH}" ];then
		fd . "${BUCK_UP_DIR_PATH}" -d 6 \
			| rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" \
			| tail -n 1 \
		2>/dev/null
		return
	fi
	echo ""
}