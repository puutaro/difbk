#!/bin/bash


substitute_unique_con_lib_path="${DIFBK_COMMON_LIB_PATH}/substitute_unique_con_by_comparing_two_lib"

. "${substitute_unique_con_lib_path}/remake_path_for_join.sh"
. "${substitute_unique_con_lib_path}/exec_substitute_unique_con.sh"


substitute_unique_con_by_comparing_two(){
	local ls_current_dir_contents_for_join="$(\
		remake_path_for_join \
			"${ls_current_dir_contents}" \
	)"
	local ls_backup_dir_c_for_diff_for_join="$(\
		remake_path_for_join \
			"${ls_backup_dir_c_for_diff}" \
	)"
	LS_CREATE_BUCKUP_MERGE_CONTENTS="$(\
		exec_substitute_unique_con \
			"${ls_current_dir_contents_for_join}" \
			"${ls_backup_dir_c_for_diff_for_join}" \
			"1"
	)"
	LS_DELETE_BUCKUP_MERGE_CONTENTS="$(\
		exec_substitute_unique_con \
			"${ls_current_dir_contents_for_join}" \
			"${ls_backup_dir_c_for_diff_for_join}" \
			"2"
	)"
}