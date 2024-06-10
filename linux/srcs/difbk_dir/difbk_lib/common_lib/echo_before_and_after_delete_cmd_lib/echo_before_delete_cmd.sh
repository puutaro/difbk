#!/bin/bash


echo_before_delete_cmd_lib_path="${ECHO_BEFORE_AND_AFTER_DELETE_CMD_LIB_PATH}/echo_before_delete_cmd_lib"
. "${echo_before_delete_cmd_lib_path}/echo_datetime_when_delete_before_time.sh"

unset -v echo_after_delete_cmd_lib_path


echo_before_delete_cmd(){
	local minits_depth_paths_con="${1}"
	local DB_OPTION_ENTRY="${2}"
	case "${DB_OPTION_ENTRY:-}" in 
		"") echo ""
			return
	;; esac 
	local db_option_source="$(\
		echo_datetime_when_delete_before_time \
			"${minits_depth_paths_con}" \
			"${DB_OPTION_ENTRY}" \
	)"
	case "${db_option_source}" in 
		"") echo ""
			return
	;; esac
	local sed_db_option=$(\
		echo "${DESC_PREFIX}.*${db_option_source-}" \
			| sed  's/\//\\\//g'\
	)
	echo " | sed -n '/${diff_prefix:-}${sed_db_option}/,\$!p'"
}