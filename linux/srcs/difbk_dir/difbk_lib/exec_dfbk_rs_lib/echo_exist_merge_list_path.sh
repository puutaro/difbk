#!/bin/bash


echo_exist_merge_list_path(){
	local file_path_with_merge_or_gip="${1}"
	local merge_list_path_filtered_by_grep="$(\
		echo "${file_path_with_merge_or_gip}" \
			| rga \
				-e "^../${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$" \
				-e "^${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$" \
			|| e=$? \
	)"
	test \
		-e "${merge_list_path_filtered_by_grep}" \
	&& echo "${merge_list_path_filtered_by_grep}" \
	|| echo ""
}