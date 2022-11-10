#!/bin/bash


echo_j_option_janre_by_how_merge_list_path(){
	local j_option_arg="${1}"
	local exist_j_option_path="$(\
		echo "${j_option_arg}" \
			| rga "${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$" \
		)"
	if [ -e "${exist_j_option_path}" ] ;then 
		echo ${J_OPTION_WHEN_MERGE_LIST_PATH}; 
		return
	fi
	expr "${j_option_arg}" + 1 \
		>&/dev/null \
	&& echo "${J_OPTION_WHEN_MERGE_LIST_NUM}" \
	&& return \
	|| e=$?
	echo "${J_OPTION_WHEN_NO_MERGE_LIST_PATH}"
}