#!/bin/bash



j_option_check_for_rbk(){
	
	expr "${J_OPTION}" : "[0-9]*$" >&/dev/null
	local err_status=$?
	case "${err_status}" in "1") echo "j option must be 0 over number"; exit 0 ;;esac
	case "${J_OPTION}" in "0") echo "j option must be 0 over number"; exit 0 ;;esac
}


j_option_path_check(){
	case "$(echo "${J_OPTION}" | grep "/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}$")" in
		"") return
	;; esac
	if [ ! -f "${J_OPTION}" ];then
		return
	fi
}