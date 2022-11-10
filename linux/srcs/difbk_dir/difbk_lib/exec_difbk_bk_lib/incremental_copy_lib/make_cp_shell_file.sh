#!/bin/bash


make_cp_shell_file(){
	local copy_source_contents="${1}"
	local file_cp_shell_path="${2}"
	local sed_buck_up_create_dir_path="${3}"
	echo "${copy_source_contents}" \
		| rga -v "${CHECH_SUM_DIR_INFO}" \
		| cut -f2 \
		| sed \
			-re "s/(.*)/cp -arvf \"${SED_TARGET_PAR_DIR_PATH}\1\"\t\"\1\"/" \
			-e "s/\t\"\/${BUCK_UP_DIR_NAME}\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/${BACKUP_CREATE_DIR_NAME}\//\t\"/" \
			-e "s/\t\"/\t\"${sed_buck_up_create_dir_path}\//" \
			-e 's/\/\//\//' \
			-re "s/\t(\".*\")/\t\1 \&\& gzip\t\1 \&\& mv\t\1${GGIP_EXETEND}\t\1${DFBK_GGIP_EXETEND} || e=\$\? \&/" \
			-e 's/\t/\ /g' \
			-e '/^$/d' \
			-e "1000~2000 i wait" \
			-e '$ a wait' \
		> "${file_cp_shell_path}"
}