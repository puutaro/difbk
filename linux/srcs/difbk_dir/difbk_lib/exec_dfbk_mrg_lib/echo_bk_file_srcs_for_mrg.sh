#!/bin/bash


echo_bk_file_srcs_for_mrg(){
	local bk_all_srcs=$(\
		fd -IH -t f . "${BUCK_UP_DIR_PATH}" \
			| sed "s/^${SED_TARGET_PAR_DIR_PATH}//" \
			| sort -r\
	)
	local bk_dir_srcs=$(\
		fd -IH -t d . "${BUCK_UP_DIR_PATH}" \
			| sed "s/^${SED_TARGET_PAR_DIR_PATH}//" \
			| sort -r\
	)
	join -v 1 \
		<(\
			echo "${bk_all_srcs}" \
			| sed 's/\ /'${DIFBK_BLANK_MARK}'/g' \
			| sort \
		) \
		<(\
			echo "${bk_dir_srcs}" \
			| sed 's/\ /'${DIFBK_BLANK_MARK}'/g' \
			| sort\
		)  \
	| sed 's/'${DIFBK_BLANK_MARK}'/\ /g'
}