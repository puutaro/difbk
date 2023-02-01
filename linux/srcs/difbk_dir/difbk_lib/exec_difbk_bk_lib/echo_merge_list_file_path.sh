#!/bin/bash


echo_merge_list_file_path(){
	local j_option="${1}"
	case "${j_option}" in 
		"") j_option=1 
			echo_buckup_merge_list_for_bk_or_rbk \
				"${j_option}"
			return
		;;
	esac
	case "${j_option}" in 
		"0") 
			exit 0
			;;
	esac
	expr "${j_option}" : "[0-9]*$" >&/dev/null
	local err_status=$?
	case "${err_status}" in 
		"0") 
			echo_buckup_merge_list_for_bk_or_rbk \
				"${j_option}"
			return
				;;
	esac

	echo_by_validation_merge_list_path_for_rbk \
		"${j_option}"


}


echo_buckup_merge_list_for_bk_or_rbk(){
	local j_option="${1}"
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


echo_by_validation_merge_list_path_for_rbk(){
	local merge_list_path_entry="${1}"
	if [ ! -f "${merge_list_path_entry}" ]; then
		exit 0
	fi

	local merge_list_name_check="$(\
		echo "${merge_list_path_entry}" \
		| rga "${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$" \
	)" 
	case "${merge_list_name_check}" in
		"")
			exit 0
			;;
	esac
	echo "${merge_list_path_entry}"
}