#!/bin/bash


echo_day_depth_path_list(){
	local delete_supper_merge_list_path="${1}"
	local sed_grep_base_rgi_path=$(\
	echo ${delete_supper_merge_list_path} \
		| sed \
			-e 's/^'${SED_TARGET_PAR_DIR_PATH}'\//\//' \
			-e 's/\/[0-9]\{4\}\/'${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}'.*//' \
		| sed 's/\//\\\//g'\
	)
	local day_depth=3
	fd \
		-t d \
		--max-depth ${day_depth} \
		. ${BUCK_UP_DIR_PATH} \
	| rga "${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}" \
	| sort \
	| sed -n '/'${sed_grep_base_rgi_path}'/,$!p'
}