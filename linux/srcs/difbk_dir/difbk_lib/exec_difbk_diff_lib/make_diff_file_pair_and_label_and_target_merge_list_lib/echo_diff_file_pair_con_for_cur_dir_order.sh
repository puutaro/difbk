#!/bin/bash


echo_diff_file_pair_con_for_cur_dir_order(){
	local dfbk_create_con_path="${1}"
	cat \
		<(\
			echo "${TARGET_MERGE_LIST}" \
			| rga -v "${CHECH_SUM_DIR_INFO}" \
			| sed -r "s/(${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})(.*)/\1\t\2/"\
		) \
		<(\
			cat "${dfbk_create_con_path}" \
			| rga -v "${CHECH_SUM_DIR_INFO}" \
			| cut -f2 \
			| sed -r "s/(.*)/-\t\1/"\
		) \
	| sort -rk 2,2 \
	| uniq -f 1 -D \
	| sed -r \
		-e "1~2s/^(.*)\t(.*)$/\1\2${SED_DFBK_GGIP_EXETEND}/" \
		-e '0~1s/^-(.*)\t(.*)$/..\1\2/'
}