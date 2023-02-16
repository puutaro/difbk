#!/bin/bash


display_merge_list_by_every(){
	local desk_rga_cmd="${1}"
	local desk_rga_v_cmd="${2}"
	echo_buckup_merge_list_for_lrs \
	| sed 's/'${SED_TARGET_PAR_DIR_PATH}'/../' \
	| nl -n ln \
	| sed \
		-re "s/^([0-9]{1,20})\ *\t(.*)/desk_path=\$(echo \"\2\" | sed 's\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}.*\/${BUCKUP_DESC_FILE_NAME}\/')\; [ -e \"\${desk_path}\" ] \&\& cat \"\${desk_path}\" | sed 's\/^\/\[\1\]\t:desk: \/';echo \"\n\";echo \"\[\1\]\t\2\"/e" \
	| sed \
		-e '/^$/d' \
		-re "s/(^\[[0-9]{1,6}\])/\x1b[38;5;2m\1\x1b[0m/g" \
		-re "s/(^\([0-9]{1,6}\))/\x1b[1;38;5;2m\1\x1b[0m/g" \
		-re "s/\t((:desk:\ .*))/\t\x1b[38;5;20m\1\x1b[0m/g"\
	| sed \
		-e '1s/^/echo "/' \
		-e  '$s/$/"/' \
	> "${EXEC_ECHO_LRS_PATH}"
	local LANG="ja_JP.UTF-8" 
	eval "bash \"\${EXEC_ECHO_LRS_PATH}\" ${before_and_after_delete_cmd} ${desk_rga_cmd} ${desk_rga_v_cmd}" \
		| sed '/^--$/d' \
		| less -XR
}


echo_buckup_merge_list_for_lrs(){
	case "${FULL_OPTION}" in
		"")
			local normal_lrs_limit=30
			fd -d 6 -t f \
				${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}  \
				"${BUCK_UP_DIR_PATH}" \
				| rga "^${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$" \
				| sort -r \
				| head -n "${normal_lrs_limit}"
			return
			;;
	esac
	fd -d 6 -t f \
		${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}  \
		"${BUCK_UP_DIR_PATH}" \
		| rga "^${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$" \
		| sort -r

}
