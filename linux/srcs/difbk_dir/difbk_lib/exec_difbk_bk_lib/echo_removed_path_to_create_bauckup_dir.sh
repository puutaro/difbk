#!/bin/bash


echo_removed_path_to_create_bauckup_dir(){
	echo "${LS_BUCKUP_MERGE_CONTENTS}" \
		| sed 's/\t\/'${BUCK_UP_DIR_NAME}'\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/'${BACKUP_CREATE_DIR_NAME}'/\t/'
}