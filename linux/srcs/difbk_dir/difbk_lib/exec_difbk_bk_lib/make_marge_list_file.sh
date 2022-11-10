#!/bin/bash


make_marge_list_file(){
	local ls_buckup_merge_contents="${1}"
	echo "${ls_buckup_merge_contents}" \
		> "${BUCKUP_MERGE_CONTENSTS_LIST_FILE_PATH}"
	gzip ${BUCKUP_MERGE_CONTENSTS_LIST_FILE_PATH} \
		&& mv \
			"${BUCKUP_MERGE_CONTENSTS_LIST_FILE_PATH}${GGIP_EXETEND}" \
			"${BUCKUP_MERGE_CONTENSTS_LIST_FILE_PATH}${DFBK_GGIP_EXETEND}"
}