#!/bin/bash


echo_ls_current_dir_contents(){
	cat \
		<(\
			join -v 1 \
				<(\
					cat "${DFBK_CUR_FD_CON_FILE_PATH}" \
						| sed \
							-e 's/\ /'${DIFBK_BLANK_MARK}'/g' \
							-e 's/\ /'${DIFBK_BLANK_MARK}'/g' \
						| sort \
				) \
				<(\
					cat "${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH}" \
						| sed \
							-re 's/^([0-9]{1,100})\ */\1\t/' \
							-e 's/\ /\t/' \
						| cut -f3 \
						| sed 's/\ /'${DIFBK_BLANK_MARK}'/g' \
						| sort \
				) \
			| sed \
				-e 's/'${DIFBK_BLANK_MARK}'/\ /g' \
				-e 's/^/'${CHECH_SUM_DIR_INFO}'\t/' \
		) \
		<(\
			cat "${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH}" \
				| sed \
					-re 's/^([0-9]{1,100})\ */\1\t/' \
					-e 's/\ /\t/' \
				| cut -f1,3 \
		) \
		| sed 's/'${SED_TARGET_PAR_DIR_PATH}'//g' \
		| sort -k 2,2
}