#!/bin/bash


checksum_calc_and_write_out_to_file(){
	local difbk_sum_dummy_file_name="check_sum_dummy_file"
	local dfbk_exec_sum_file_path="${DFBK_SETTING_DIR_PATH}/exec_sum.sh"
	eval "\
		fd -IH \
			$(\
				cat "${DFBK_IGNORE_FILE_PATH}" \
					| rga -v "^#" \
					| sed \
						-e 's/\[/\\\[/g' \
						-e 's/\]/\\\]/g' \
						-re "s/^([^ ])/\/\1/" \
						-re "s/([^ ])$/\1/" \
						-e 's/\/\//\//' \
						-re 's/^([^ ])/ -E\ \1/' \
					| tr -d '\n'\
			) \
			. \
			\"${TARGET_DIR_PATH}\"\
		" \
		| rga -v "/${DFBK_UTIL_DIR_NAME}" \
		| sed "1i ${TARGET_DIR_PATH}" \
		| rga -v "${DFBK_IGNORE_FILE_NAME}$" \
		| rga -v "${DIFBK_EXCLUDE_DS_STORE}$" \
			2>/dev/null \
			> ${DFBK_CUR_FD_CON_FILE_PATH} \
	&& cat "${DFBK_CUR_FD_CON_FILE_PATH}" \
		| sed \
			-e '/^$/d' \
			-e "s/^/\"/" \
			-e "s/$/\" \\\\/" \
			-e '1i sum \\' \
		| awk \
			-v DFBK_CHECK_SUM_CULC_DIR_PATH="${DFBK_CHECK_SUM_CULC_DIR_PATH}"  \
			'(NR%50==0){
				$0=$0"\n""> ""\042"DFBK_CHECK_SUM_CULC_DIR_PATH"/ch_file_"int(rand() * 100000)int(rand() * 100000)int(rand() * 100000)int(rand() * 100000)int(rand() * 100000)int(rand() * 100000)"\042"" &""\nsum ""\\"
			}{
				print
			}' \
		| sed \
			-e "$ s/\\\\$/\"${difbk_sum_dummy_file_name}\" > \"${SED_DFBK_CHECK_SUM_CULC_DIR_PATH}\/ch_file_${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}\" \&/" \
			-e '$ a wait' \
			> "${dfbk_exec_sum_file_path}" \
	&& LANG=C bash "${dfbk_exec_sum_file_path}" 2>/dev/null \
	&& fd -t f . "${DFBK_CHECK_SUM_CULC_DIR_PATH}" \
	| sed \
		-e '/^$/d' \
		-e "s/^/\"/" \
		-e "s/$/\" \\\\/" \
		-e '1i cat \\' \
	| awk -v DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH=${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH} '(NR%200==0){$0=$0"\n"">> ""\042"DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH"\042""\ncat ""\\"}{print}' \
	| sed "$ s/\\\\$/ >> \"${SED_DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH}\"/" \
		> "${DFBK_CHECK_SUM_OUTPUT_FILE_PATH}" \
	&& bash "${DFBK_CHECK_SUM_OUTPUT_FILE_PATH}"
}