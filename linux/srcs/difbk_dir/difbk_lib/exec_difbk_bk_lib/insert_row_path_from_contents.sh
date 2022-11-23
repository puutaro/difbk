#!/bin/bash


insert_row_path_from_contents(){
	if [ -z "${LS_BUCKUP_MERGE_CONTENTS}" ] \
		&& [ -z "${LS_CREATE_BUCKUP_MERGE_CONTENTS}" ]; then
		 echo "${LS_BUCKUP_MERGE_CONTENTS}"
		 return
	fi
	local sed_buck_up_create_dir_ralative_path="$(\
		echo "${BUCK_UP_CREATE_DIR_RALATIVE_PATH}" \
		| sed 's/\//\\\//g'\
	)"
	local insert_contents="$(\
			echo "${LS_CREATE_BUCKUP_MERGE_CONTENTS}"\
			| sed 's/\t\/'${TARGET_DIR_NAME}'\//\t'${sed_buck_up_create_dir_ralative_path}'\/'${TARGET_DIR_NAME}'\//g' \
			| sed 's/\t\/'${TARGET_DIR_NAME}'$/\t'${sed_buck_up_create_dir_ralative_path}'\/'${TARGET_DIR_NAME}'/g'\
	)"
	cat \
		<(echo "${LS_BUCKUP_MERGE_CONTENTS}") \
		<(echo "${insert_contents}") \
		| sed '/^$/d'
}