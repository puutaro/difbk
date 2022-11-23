#!/bin/bash


echo_target_merge_list_in_path_search(){
	local j_option_janre="${1}"
	case "${j_option_janre}" in 
	"${J_OPTION_WHEN_MERGE_LIST_NUM}"|"${J_OPTION_WHEN_MERGE_LIST_PATH}") 
		local target_merge_list_soruce=$(\
			echo "${TARGET_MERGE_LIST}" \
				| sed  \
					-e 's/^'${SED_TARGET_PAR_DIR_PATH}'//' \
				| sed  's/^\.\.//' \
				| sed  's/^/../'\
		)
		eval "echo \"${target_merge_list_soruce}\" ${NO_SED_RGA_CMD}"
		return
		;; 
	esac
	echo "${TARGET_MERGE_LIST}"
}