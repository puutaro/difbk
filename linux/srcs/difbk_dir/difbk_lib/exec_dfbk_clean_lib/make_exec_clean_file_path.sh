#!/bin/bash

make_exec_clean_file_path_lib_path="${EXEC_DFBK_CLEAN_LIB_PATH}/make_exec_clean_file_path_lib"
. "${make_exec_clean_file_path_lib_path}/echo_delete_buckup_file_type_list_con.sh"
. "${make_exec_clean_file_path_lib_path}/echo_clean_file_list_con.sh"
. "${make_exec_clean_file_path_lib_path}/execute_make_exec_clean_file_path.sh"


make_exec_clean_file_path(){
	local exec_clean_file_path="${1}"
	local LANG=C
	local delete_buckup_file_type_list_con=$(\
		echo_delete_buckup_file_type_list_con \
			"${day_depth_path_lists[@]}"\
	)
	
	local clean_file_list_con=$(\
		echo_clean_file_list_con \
			"${delete_buckup_file_type_list_con}" \
			"${delete_supper_merge_list_contents}" \
	)
	CLEAN_FILE_NUM="$(\
		echo "${clean_file_list_con}" \
		| wc -l\
	)"
	execute_make_exec_clean_file_path \
		"${exec_clean_file_path}" \
		"${clean_file_list_con}"
}