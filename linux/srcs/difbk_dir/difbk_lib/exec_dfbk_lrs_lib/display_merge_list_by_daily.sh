#!/bin/bash


display_merge_list_by_daily(){
	local LANG="ja_JP.UTF-8" 
	fd . "${BUCK_UP_DIR_PATH}" -d 6 -t f \
		| rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" \
		| sort -r \
		| sed -r "s/^(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})/\2\t\1/" \
		| uniq -f 1  \
		| sed \
			-re "s/^(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})\t(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})/\2\1/"  \
			-e 's/'${SED_TARGET_PAR_DIR_PATH}'/../' \
		| nl -n ln \
		| sed \
			-r "s/^([0-9]{1,20})\ *\t(.*)/desk_path=\$(fd -d 2 -t f ${BUCKUP_DESC_FILE_NAME} \$(echo \"\2\" | sed 's\/[0-9]\\\{4\\\}\\\\\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}.*\/\/'))\; [ -n \"\${desk_path}\" ] \&\& cat \${desk_path} | sed 's\/^\/\[\1\]\t:desk: \/';echo \"\n\";echo \"\[\1\]\t\2\"/e" \
			2>/dev/null \
		| sed \
			-e '/^$/d' \
			-re "s/(^\[[0-9]{1,6}\])/\x1b[38;5;2m\1\x1b[0m/g" \
			-re "s/(^\([0-9]{1,6}\))/\x1b[1;38;5;2m\1\x1b[0m/g" \
			-re "s/\t((:desk:\ .*))/\t\x1b[38;5;20m\1\x1b[0m/g" \
		| less -XR
}