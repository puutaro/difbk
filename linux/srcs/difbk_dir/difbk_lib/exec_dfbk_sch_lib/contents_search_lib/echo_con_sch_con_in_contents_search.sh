#!/bin/bash


echo_con_sch_con_in_contents_search_lib_path="${CONTENTS_SEARCH_LIB_PATH}/echo_con_sch_con_in_contents_search_lib"
. "${echo_con_sch_con_in_contents_search_lib_path}/echo_sch_con_when_no_merge_in_con_sch.sh"
. "${echo_con_sch_con_in_contents_search_lib_path}/echo_sch_con_when_merge_list_in_con_sch.sh"
unset -v echo_con_sch_con_in_contents_search_lib_path


echo_con_sch_con_in_contents_search(){
	local j_option_janre="${1}"
	local after_before="${2}"
	case "${j_option_janre}" in 
    "${J_OPTION_WHEN_NO_MERGE_LIST_PATH}")
		echo_sch_con_when_no_merge_in_con_sch \
			"${after_before}" \
				"${TARGET_MERGE_LIST}" \
				"${RGA_OPTION[@]}"
        ;;
    "${J_OPTION_WHEN_MERGE_LIST_NUM}"|"${J_OPTION_WHEN_MERGE_LIST_PATH}")
		echo_sch_con_when_merge_list_in_con_sch \
			"${after_before}" \
				"${TARGET_MERGE_LIST}" \
				"${RGA_OPTION[@]}"	
        ;;
	esac
}