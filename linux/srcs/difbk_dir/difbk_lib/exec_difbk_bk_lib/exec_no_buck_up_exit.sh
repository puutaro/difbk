#!/bin/bash


exec_no_buck_up_exit(){
	local rs_bk_option="${RS_BK_OPTION}"
	local no_restore_message="${2}"
	if [  -n "${rs_bk_option}" ] \
		&& [ -z "${LS_DELETE_BUCKUP_MERGE_CONTENTS}" ]; then
			echo "${no_restore_message}"
			exit 0
			return
	fi
	case "${rs_bk_option}" in
		"") ;;
		*) return ;;
	esac
	local latest_merge_list_num=1
	case "${J_OPTION}" in
		""|"${latest_merge_list_num}") ;;
		*) return ;;
	esac
	case "${LS_CREATE_BUCKUP_MERGE_CONTENTS}" in 
		"")
			echo "no buckup(create) target file"
			exit 0; 
		;;
	esac
}