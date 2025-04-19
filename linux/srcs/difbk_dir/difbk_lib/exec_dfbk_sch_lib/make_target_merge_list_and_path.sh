#!/bin/bash


make_target_merge_list_and_path_lib_path="${EXEC_DFBK_SCH_LIB_PATH}/make_target_merge_list_and_path_lib"
. "${make_target_merge_list_and_path_lib_path}/make_target_list_and_path_when_no_merge_list_path.sh"
. "${make_target_merge_list_and_path_lib_path}/make_target_list_and_path_when_merge_list_num.sh"
. "${make_target_merge_list_and_path_lib_path}/make_target_list_and_path_when_merge_list_path.sh"

unset -v make_target_merge_list_and_path_lib_path


make_target_merge_list_and_path(){
	local j_option_janre="${1}"
	local j_option_arg="${2}"
	case "${j_option_janre}" in 
	"${J_OPTION_WHEN_NO_MERGE_LIST_PATH}") 
		TARGET_MERGE_LIST=""
		make_target_list_and_path_when_no_merge_list_path
		;;
	"${J_OPTION_WHEN_MERGE_LIST_NUM}")
		TARGET_MERGE_LIST=""
		TARGET_MERGE_LIST_PATH=""
		make_target_list_and_path_when_merge_list_num \
			"${j_option_arg}"
		;;
	"${J_OPTION_WHEN_MERGE_LIST_PATH}")
		TARGET_MERGE_LIST=""
		TARGET_MERGE_LIST_PATH=""
		make_target_list_and_path_when_merge_list_path \
			"${j_option_arg}"
		;;
esac
}