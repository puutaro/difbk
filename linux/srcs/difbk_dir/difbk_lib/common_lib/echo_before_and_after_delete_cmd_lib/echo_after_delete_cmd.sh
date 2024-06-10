#!/bin/bash


echo_after_delete_cmd_lib_path="${ECHO_BEFORE_AND_AFTER_DELETE_CMD_LIB_PATH}/echo_after_delete_cmd_lib"
. "${echo_after_delete_cmd_lib_path}/echo_datetime_when_delete_after_time.sh"

unset -v echo_after_delete_cmd_lib_path


echo_after_delete_cmd(){
	local minits_depth_paths_con="${1}"
	local DA_OPTION_ENTRY="${2}"
	case "${DA_OPTION_ENTRY:-}" in 
		"") echo ""
			return
	;; esac 
	local da_option_source="$(\
		echo_datetime_when_delete_after_time \
			"${minits_depth_paths_con}" \
			"${DA_OPTION_ENTRY}" \
	)"
	case "${da_option_source}" in 
		"") echo ""
			return
	;; esac
	local sed_da_option=$(\
		echo "${DESC_PREFIX}.*${da_option_source-}" \
			| sed  's/\//\\\//g'\
	)
	echo " | sed -n '1,/${diff_prefix:-}${sed_da_option:-}/!p' ${diff_delete_sed:-}"
}