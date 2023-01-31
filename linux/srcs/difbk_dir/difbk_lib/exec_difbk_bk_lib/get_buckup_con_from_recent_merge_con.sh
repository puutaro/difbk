#!/bin/bash


get_buckup_con_from_recent_merge_con_lib_path="${DIFBK_BK_LIB_DIR_PATH}/get_buckup_con_from_recent_merge_con_lib"
. "${get_buckup_con_from_recent_merge_con_lib_path}/exec_get_buckup_con_from_recent_merge_con.sh"

unset -v get_buckup_con_from_recent_merge_con_lib_path


get_buckup_con_from_recent_merge_con(){
	local merge_list_file_path="${1}"
	LS_BUCKUP_MERGE_CONTENTS="$(\
		exec_get_buckup_con_from_recent_merge_con \
			"${merge_list_file_path}" \
	)"
	case "${FULL_OPTION}" in 
		"");; 
		*) LS_BUCKUP_MERGE_CONTENTS="";; 
	esac 
	if [ ! -d "${BUCK_UP_DIR_PATH}" ];then mkdir -p "${BUCK_UP_DIR_PATH}" ;fi
	if [ ! -d ${DFBK_SETTING_DIR_PATH}  ];then mkdir -p ${DFBK_SETTING_DIR_PATH} ;fi
	if [ ! -d "${BUCK_UP_DIR_PATH}" ];then mkdir -p "${BUCK_UP_DIR_PATH}" ;fi
}