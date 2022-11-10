#!/bin/bash


end_judge_by_merge_list_path_and_restore_target_dir_path(){
	local exist_merge_list_path="${1}"
	local restore_target_dir_path="${2}"
	case "${exist_merge_list_path}" in
	"")
		echo "no exist this merge list file path: ${exist_merge_list_path}"
		exit 0
	;;
	esac
	if [ -z "${exist_merge_list_path}" ] \
		|| [ -z "${restore_target_dir_path}" ]; then exit 0;fi
}