#!/bin/bash


make_target_list_and_path_when_merge_list_num(){
	local j_option_arg="${1}"
	local merge_list_depth=6
	TARGET_MERGE_LIST_PATH="$(\
			fd . "${BUCK_UP_DIR_PATH}" \
				-d ${merge_list_depth} \
			| rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" \
			| sort -r \
			| sed  -n ''${j_option_arg}'p'\
	)"
	TARGET_MERGE_LIST=$(\
		zcat  "${TARGET_MERGE_LIST_PATH}" \
		| rga -v "${CHECH_SUM_DIR_INFO}" \
		| cut -f2  \
		| sed  's/^/'${SED_TARGET_PAR_DIR_PATH}'/' \
		| sed  "s/$/${SED_DFBK_GGIP_EXETEND}/" \
		| sed  "s/${SED_GGIP_EXETEND}${SED_DFBK_GGIP_EXETEND}$/${SED_GGIP_EXETEND}/" \
		| sed  "s/\@${SED_DFBK_GGIP_EXETEND}$/\@/" \
		| sort -r\
	)
}