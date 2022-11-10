#!/bin/bash


insert_row_path_from_contents(){
	local buckup_marge_contets="${1}"
	local create_contents="${2}"
	if [ -z "${buckup_marge_contets}" ] \
		&& [ -z "${create_contents}" ]; then
		 echo "${LS_BUCKUP_MERGE_CONTENTS}"
		 return
	fi
	local sed_buck_up_create_dir_ralative_path="$(\
		echo "${BUCK_UP_CREATE_DIR_RALATIVE_PATH}" \
		| sed 's/\//\\\//g'\
	)"
	local insert_contents="$(\
			echo "${create_contents}"\
			| sed 's/\t\/'${TARGET_DIR_NAME}'\//\t'${sed_buck_up_create_dir_ralative_path}'\/'${TARGET_DIR_NAME}'\//g' \
			| sed 's/\t\/'${TARGET_DIR_NAME}'$/\t'${sed_buck_up_create_dir_ralative_path}'\/'${TARGET_DIR_NAME}'/g'\
	)"
	cat \
		<(echo "${buckup_marge_contets}") \
		<(echo "${insert_contents}") \
		| sed '/^$/d'
}