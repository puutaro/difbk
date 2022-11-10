#!/bin/bash


incremental_copy_lib_path="${DIFBK_BK_LIB_DIR_PATH}/incremental_copy_lib"
. "${incremental_copy_lib_path}/echo_updated_old_backup_create_dir_path.sh"
. "${incremental_copy_lib_path}/echo_mkdir_shell_con.sh"
. "${incremental_copy_lib_path}/make_cp_shell_file.sh"

unset -v incremental_copy_lib_path


incremental_copy(){
	local copy_source_contents="${1}"
	local sed_buck_up_create_dir_path=$(\
			echo "${BACKUP_CREATE_DIR_PATH}" \
			| sed 's/\//\\\//g'\
	)
	local mkdir_shell_path="${DFBK_SETTING_DIR_PATH}/copy_mkdir.sh"
	local copy_contents=$(\
		echo_updated_old_backup_create_dir_path \
			"${copy_source_contents}" \
			"${sed_buck_up_create_dir_path}" \
		)
	local mkdir_shell_con=$(\
		echo_mkdir_shell_con \
			"${copy_contents}" \
	)
	echo "${mkdir_shell_con}" \
		| sed \
			-e "1000~2000 i wait" \
			-e '$ a wait'  \
		> ${mkdir_shell_path}
	bash "${mkdir_shell_path}"
	wait
	local file_cp_shell_path="${DFBK_SETTING_DIR_PATH}/copy_file.sh"
	make_cp_shell_file \
		"${copy_source_contents}" \
		"${file_cp_shell_path}" \
		"${sed_buck_up_create_dir_path}"
	bash "${file_cp_shell_path}"
}
