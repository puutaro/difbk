#!/bin/bash


exec_copy_and_unzip_exclude_gz_and_at(){
	local cp_row_con="${1}"
	local sed_buck_up_create_dir_path="${2}"
	local file_cp_shell_path="${3}"
	echo "${cp_row_con}" \
		| rga -v "\.gz$" \
		| rga -v "@$" \
		| sed -r "s/(.*)/\"${SED_TARGET_PAR_DIR_PATH}\1\"\t\"\1\"/" \
		| sed \
			-e "s/\t\"\/${BUCK_UP_DIR_NAME}\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/${BACKUP_CREATE_DIR_NAME}\//\t\"/" \
			-e "s/\t\"/\t\"${sed_buck_up_create_dir_path}\//" \
		| sed 's/\/\//\//' \
		| sed -r "s/(\"[^\"]*\")\t(\"[^\"]*\")/cp -arvf \1${DFBK_GGIP_EXETEND} \2${GGIP_EXETEND} \&\& gunzip -f\t\2${GGIP_EXETEND} || cp -arvf \1 \2 || e=\$\? \&/" \
		| sed \
			-e 's/\t/\ /g' \
			-e '/^$/d' \
			-e "1000~2000 i wait" \
			-e '$ a wait' \
		> "${file_cp_shell_path}"
	wait
}