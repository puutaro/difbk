#!/bin/bash


sed_target_desk_con(){
	cat "$(\
			echo "${TARGET_MERGE_LIST_PATH}" \
				| sed  \
					-e "s/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}.*/${BUCKUP_DESC_FILE_NAME}/"\
		)" \
	| sed  -r 's/(.*)/(\1)/' \
	| sed  -r 's/([^a-zA-Z0-9_])/\\\1/g'
}