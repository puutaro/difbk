#!/bin/bash


echo_updated_old_backup_create_dir_path(){
	local sed_buck_up_create_dir_path="${1}"
	echo "${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
		| sed \
			-e 's/\t\/'${BUCK_UP_DIR_NAME}'\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/'${BACKUP_CREATE_DIR_NAME}'\//\t/' \
			-e 's/\t/\t'${sed_buck_up_create_dir_path}'/' \
			-e 's/\/\//\//' \
			-e '/^$/d'
}