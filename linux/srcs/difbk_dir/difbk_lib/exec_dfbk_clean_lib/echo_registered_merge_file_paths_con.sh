#!/bin/bash


echo_registered_merge_file_paths_con(){
	local merge_list_depth=6
	fd . \
		"${BUCK_UP_DIR_PATH}" \
		-d "${merge_list_depth}" -t f \
	| rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" \
	| sort \
	| sed \
		-r "s/^(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})/\2\t\1/" \
	| uniq -f 1 \
	| sed \
		-r "s/^(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})\t(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})/\2\1/" \
	| sort -r \
	| head -n ${DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST} \
	| sort
}