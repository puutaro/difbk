#!/bin/bash


ECHO_BEFORE_AND_AFTER_DELETE_CMD_LIB_PATH="${DIFBK_COMMON_LIB_PATH}/echo_before_and_after_delete_cmd_lib"
. "${ECHO_BEFORE_AND_AFTER_DELETE_CMD_LIB_PATH}/echo_after_delete_cmd.sh"
. "${ECHO_BEFORE_AND_AFTER_DELETE_CMD_LIB_PATH}/echo_before_delete_cmd.sh"


unset -v ECHO_BEFORE_AND_AFTER_DELETE_CMD_LIB_PATH


echo_before_and_after_delete_cmd(){
	local rga_after_num="${1}"
	local differ_option="${2:-}"
	case "${differ_option:-}" in 
		"");; 
		*) diff_prefix='\[2\] '
	;; esac
	case "${rga_after_num:-}" in 
		"") ;; 
		*) local diff_delete_sed=" | sed '1,${rga_after_num}d'"
	;;esac
	case "${DB_OPTION_ENTRY:-}${DA_OPTION_ENTRY:-}" in
		"") 
			echo ""
			return		
	;;esac 
	local minutes_dir_depth=4
	local minits_depth_paths_con=$(\
		fd . "../${BUCK_UP_DIR_NAME}" \
			-d "${minutes_dir_depth}" -t d \
		| rga "[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}" \
		| sed \
			-e 's/\.\.\/'${BUCK_UP_DIR_NAME}'\///'
	)
	local before_delete_cmd="$(\
		echo_before_delete_cmd \
			"${minits_depth_paths_con}"\
			"${DB_OPTION_ENTRY}"\
	)"
	local after_delete_cmd="$(\
		echo_after_delete_cmd \
			"${minits_depth_paths_con}"\
			"${DA_OPTION_ENTRY}"\
	)"
	echo "${before_delete_cmd:-} ${after_delete_cmd:-}"
}
