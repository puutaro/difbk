#!/bin/bash


echo_removed_path_to_create_bauckup_dir(){
	local ls_buckup_merge_contents="${1}"
	echo "${ls_buckup_merge_contents}" \
		| sed 's/\t\/'${BUCK_UP_DIR_NAME}'\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/'${BACKUP_CREATE_DIR_NAME}'/\t/'
}