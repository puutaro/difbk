#!/bin/bash


make_target_list_and_path_when_merge_list_path(){
	local j_option_arg="${1}"
	TARGET_MERGE_LIST_PATH="${j_option_arg}"
	TARGET_MERGE_LIST=$(\
		zcat  "${j_option_arg}" \
			| rga -v "${CHECH_SUM_DIR_INFO}" \
			| cut -f2 \
			| sort -r\
	)
}