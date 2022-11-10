#!/bin/bash


COPY_AND_UNZIP_LIB_PATH="${EXEC_DFBK_RS_LIB_PATH}/copy_and_unzip_lib"

. "${COPY_AND_UNZIP_LIB_PATH}/make_mkdir_shell_path.sh"
. "${COPY_AND_UNZIP_LIB_PATH}/exec_copy_and_unzip.sh"
unset -v COPY_AND_UNZIP_LIB_PATH


copy_and_unzip(){
	local input_copy_contents="${1}"
	local restore_target_dir_path="${2}"
	local sed_restore_target_dir_path=$(\
		echo "${restore_target_dir_path}" \
			| sed 's/\//\\\//g'\
	)
	local mkdir_shell_path="${DFBK_SETTING_DIR_PATH}/copy_mkdir.sh"
	make_mkdir_shell_path \
		"${input_copy_contents}" \
		"${sed_restore_target_dir_path}" \
		"${mkdir_shell_path}"
	bash "${mkdir_shell_path}"
	unset -v mkdir_shell_path
	wait
	local file_cp_shell_path="${DFBK_SETTING_DIR_PATH}/copy_file.sh"
	local cp_row_con=$(\
		echo "${input_copy_contents}" \
			| rga -v "${CHECH_SUM_DIR_INFO}" \
			| cut -f2\
	)
	exec_copy_and_unzip \
		"${cp_row_con}" \
		"${sed_restore_target_dir_path}" \
		"${file_cp_shell_path}"
	bash "${file_cp_shell_path}"
	wait
}