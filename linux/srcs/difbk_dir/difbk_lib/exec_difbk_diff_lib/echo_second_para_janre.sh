#!/bin/bash


echo_second_para_janre(){
	local second_para="${1}"
	local filtered_second_para="$(\
		echo "${second_para}" \
			| rga "${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$"\
	)"
	if [ -e "${filtered_second_para}" ] ;then 
		echo "${JANRE_MERGE_LIST_PATH}"
		return
	fi
	expr "${second_para}" + 1 \
		>&/dev/null \
	&& echo ${JANRE_MERGE_LIST_NUM} \
	&& return || e=$?
	echo "${JANRE_NO_RELATE_MERGE_LIST}"
}
