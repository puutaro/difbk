#!/bin/bash


incremental_copy_lib_path="${EXEC_BUCKUP_IN_BK_LIB}/incremental_copy_lib"
. "${incremental_copy_lib_path}/echo_updated_old_backup_create_dir_path.sh"
. "${incremental_copy_lib_path}/echo_mkdir_shell_con.sh"
. "${incremental_copy_lib_path}/make_cp_shell_file.sh"

unset -v incremental_copy_lib_path


incremental_copy(){
	local sed_buck_up_create_dir_path=$(\
			echo "${BACKUP_CREATE_DIR_PATH}" \
			| sed 's/\//\\\//g'\
	)
	local mkdir_shell_path="${DFBK_SETTING_DIR_PATH}/copy_mkdir.sh"
	local COPY_CONTENTS=$(\
		echo_updated_old_backup_create_dir_path \
			"${sed_buck_up_create_dir_path}" \
			"${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
		)
	local mkdir_shell_con=$(\
		echo_mkdir_shell_con \
			"${COPY_CONTENTS}" \
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
		"${file_cp_shell_path}" \
		"${sed_buck_up_create_dir_path}" \
		"${LS_CREATE_BUCKUP_MERGE_CONTENTS}"
	bash "${file_cp_shell_path}"
}
