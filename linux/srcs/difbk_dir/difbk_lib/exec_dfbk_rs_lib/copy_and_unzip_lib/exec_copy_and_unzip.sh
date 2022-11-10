#!/bin/bash


exec_copy_and_unzip_lib_path="${COPY_AND_UNZIP_LIB_PATH}/exec_copy_and_unzip_lib"
. "${exec_copy_and_unzip_lib_path}/exec_copy_and_unzip_exclude_gz_and_at.sh"
. "${exec_copy_and_unzip_lib_path}/exec_copy_and_unzip_exclude_at.sh"
. "${exec_copy_and_unzip_lib_path}/exec_copy_and_unzip_exclude_gz.sh"

unset -v exec_copy_and_unzip_lib_path


exec_copy_and_unzip(){
	local cp_row_con="${1}"
	local sed_buck_up_create_dir_path="${2}"
	local file_cp_shell_path="${3}"
	exec_copy_and_unzip_exclude_gz_and_at \
		"${cp_row_con}" \
		"${sed_buck_up_create_dir_path}" \
		"${file_cp_shell_path}"
	exec_copy_and_unzip_exclude_at \
		"${cp_row_con}" \
		"${sed_buck_up_create_dir_path}" \
		"${file_cp_shell_path}"
	exec_copy_and_unzip_exclude_gz \
		"${cp_row_con}" \
		"${sed_buck_up_create_dir_path}" \
		"${file_cp_shell_path}"
}