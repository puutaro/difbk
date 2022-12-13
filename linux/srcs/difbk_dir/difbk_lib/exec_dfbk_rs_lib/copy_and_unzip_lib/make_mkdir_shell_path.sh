#!/bin/bash


make_mkdir_shell_path(){
	local sed_buck_up_create_dir_path="${1}"
	local mkdir_shell_path="${2}"
	echo "${LS_BUCKUP_MERGE_CONTENTS}" \
		| rga "${CHECH_SUM_DIR_INFO}" \
		| cut -f2 \
		| sed \
			-e 's/^\/'${BUCK_UP_DIR_NAME}'\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/'${BACKUP_CREATE_DIR_NAME}'\///' \
			-e 's/^/'${sed_buck_up_create_dir_path}'\//' \
			-e 's/\/\//\//' \
			-e '/^$/d' \
			-e "s/^/mkdir -p \"/" \
			-e "s/$/\" \&/"  \
			-e "1000~2000 i wait" \
			-e '$ a wait'  \
		> "${mkdir_shell_path}"
	wait
}