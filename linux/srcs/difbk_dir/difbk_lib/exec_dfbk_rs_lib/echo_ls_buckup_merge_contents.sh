#!/bin/bash


echo_ls_buckup_merge_contents(){
	case "${grep_path_source_against_merge_list}" in
		"");;
		*)
			local grep_path_against_merge_list=$(\
				echo "${grep_path_source_against_merge_list}" \
					| sed \
						-e 's/^'${SED_TARGET_PAR_DIR_PATH}'//g' \
						-e 's/^\///g'\
			)
			zcat "${exist_merge_list_path}" \
				| rga "${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}/${TARGET_DIR_NAME}/${grep_path_against_merge_list}" \
			|| e=$?
			return
			;;
	esac
	zcat "${exist_merge_list_path}"
}