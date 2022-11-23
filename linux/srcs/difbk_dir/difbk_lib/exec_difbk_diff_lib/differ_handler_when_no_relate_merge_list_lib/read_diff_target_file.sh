#!/bin/bash


read_diff_target_file(){
	local second_para="${1}"
	read diff_target_file < <(\
		fd -t f . \
			"${RECENT_DAY_DEPTH_PATH_LIST[@]}" \
		| sed 's/^'${SED_BUCK_UP_DIR_PATH}'//' \
		| rga "${second_para}" \
		| sort -r \
		| fzf --cycle \
			--preview="echo {} | sed 's/^/${SED_BUCK_UP_DIR_PATH}/' | sed 's/'${BACKUP_CREATE_DIR_NAME}'.*/'${BUCKUP_DESC_FILE_NAME}'/' | xargs -I{} cat {} | sed 's/^/\[description\]\ /' " \
			--preview-window='wrap,down:3' \
		| sed 's/^/\/'${BUCK_UP_DIR_NAME}'/'\
		)
}