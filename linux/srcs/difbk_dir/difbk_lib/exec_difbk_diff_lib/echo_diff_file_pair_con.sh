#!/bin/bash


echo_diff_file_pair_con_lib_path="${EXEC_DIFBK_DIFF_LIB_PATH}/echo_diff_file_pair_con_lib"
. "${echo_diff_file_pair_con_lib_path}/exec_echo_diff_file_pair_con.sh"

unset -v echo_diff_file_pair_con_lib_path


echo_diff_file_pair_con(){
	local recent_merge_list_path="${1}"
	local before_merge_list_path="${2}"
	LS_CREATE_BUCKUP_MERGE_CONTENTS=""
	LS_DELETE_BUCKUP_MERGE_CONTENTS=""
	substitute_unique_con_by_comparing_two \
		"$(zcat "${recent_merge_list_path}")" \
		"$(zcat "${before_merge_list_path}")"

	local before_day_dir_path=$(\
		echo "${before_merge_list_path}" \
		| sed \
			-e 's/'${SED_TARGET_PAR_DIR_PATH}'/\.\./' \
			-e 's/'${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}'.*//'\
	)
	local sed_before_day_dir_path=$(\
		echo "${before_day_dir_path}" \
		| sed -r 's/([^a-zA-Z0-9_])/\\\1/g'\
	)
	sed_before_diff_label=$(\
		echo "${before_day_dir_path}" \
		| sed 's/$/'${BUCKUP_DESC_FILE_NAME}'/' \
		| cat $(cat) \
		|| echo --\
	)
	sed_before_diff_label=$(\
		echo "${sed_before_diff_label}" \
		| sed \
			-re "s/(.*)/(\1) ${sed_before_day_dir_path}/" \
			-re 's/([^a-zA-Z0-9_])/\\\1/g'\
	)
	diff_file_pair_con=$(\
		exec_echo_diff_file_pair_con \
	 		"${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
	 		"${LS_DELETE_BUCKUP_MERGE_CONTENTS}"\
	)
	unset -v LS_CREATE_BUCKUP_MERGE_CONTENTS
	unset -v LS_DELETE_BUCKUP_MERGE_CONTENTS
}