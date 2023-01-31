#!/bin/bash


exec_get_buckup_con_from_recent_merge_con(){
	local merge_list_file_path="${1}"
	case "${merge_list_file_path}" in 
		"") echo ""
			return
	;; esac

	if [ -e "${merge_list_file_path}" ];then 
		zcat "${merge_list_file_path}" \
			| sed '/^$/d'
	fi
}
