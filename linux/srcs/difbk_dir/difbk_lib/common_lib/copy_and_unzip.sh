#!/bin/bash


COPY_AND_UNZIP_LIB_PATH="${DIFBK_COMMON_LIB_PATH}/copy_and_unzip_lib"

. "${COPY_AND_UNZIP_LIB_PATH}/make_mkdir_shell_path.sh"
. "${COPY_AND_UNZIP_LIB_PATH}/exec_copy_and_unzip.sh"
unset -v COPY_AND_UNZIP_LIB_PATH


copy_and_unzip(){
	local restore_target_dir_path="${1}"
	local sed_restore_target_dir_path=$(\
		echo "${restore_target_dir_path}" \
			| sed 's/\//\\\//g'\
	)
	local mkdir_shell_path="${DFBK_SETTING_DIR_PATH}/copy_mkdir.sh"
	case "${LS_BUCKUP_MERGE_CONTENTS}" in
		"") return ;; 
	esac
	echo --
	LS_BUCKUP_MERGE_CONTENTS=$(\
		cat \
			<(echo "${LS_BUCKUP_MERGE_CONTENTS}")\
			<(\
				echo "${LS_BUCKUP_MERGE_CONTENTS}" \
				| sed -r \
					-e 's/\/[^/]*$//' \
					-e 's/(.*)\t(.*)/'${CHECH_SUM_DIR_INFO}'\t\2/' \
				| sort -k 2,2 \
				| uniq -f 1 \
			)\
	)
	make_mkdir_shell_path \
		"${sed_restore_target_dir_path}" \
		"${mkdir_shell_path}" \
		"${LS_BUCKUP_MERGE_CONTENTS}"
	bash "${mkdir_shell_path}"
	unset -v mkdir_shell_path
	wait
	local file_cp_shell_path="${DFBK_SETTING_DIR_PATH}/copy_file.sh"
	local cp_row_con=$(\
		echo "${LS_BUCKUP_MERGE_CONTENTS}" \
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