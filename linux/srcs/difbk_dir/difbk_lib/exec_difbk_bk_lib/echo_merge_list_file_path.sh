#!/bin/bash


echo_merge_list_file_path(){
	local j_option="${1}"
	case "${j_option}" in 
		"") j_option=1 
		;;
	esac
	if [ -e "${BUCK_UP_DIR_PATH}" ];then
		fd . "${BUCK_UP_DIR_PATH}" -d 6 \
			| rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" \
			| sort -r \
			| sed -n "${j_option}p" \
		2>/dev/null
		return
	fi
	echo ""
}
