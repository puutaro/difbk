#!/bin/bash


make_restore_target_file_path(){
	local restore_target_file_source_path="${1}"
	local restore_target_dir_path="${2}"
	case "${restore_target_dir_path}" in
		"") ;;
		*)
			restore_target_file_path="${restore_target_dir_path}"
			C_OPTION="-c"
			return
			;;
	esac
	restore_target_file_path=$(\
		echo "${restore_target_file_source_path}" \
			| sed \
				-e "s/^${SED_BUCK_UP_DIR_PATH}\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/${BACKUP_CREATE_DIR_NAME}\/${TARGET_DIR_NAME}\///g" \
				-e "s/^\.\.\/${BUCK_UP_DIR_NAME}\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/${BACKUP_CREATE_DIR_NAME}\/${TARGET_DIR_NAME}\///g" \
				-e 's/'${SED_DFBK_GGIP_EXETEND}'$//g'\
	)
}