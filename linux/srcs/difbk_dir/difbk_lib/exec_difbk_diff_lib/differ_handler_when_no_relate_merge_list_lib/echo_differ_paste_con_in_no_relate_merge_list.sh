#!/bin/bash


echo_differ_paste_con_in_no_relate_merge_list(){
	local diff_target_file_path="${1}"
	local sed_diff_target_file="${2}"
	paste \
		<(\
			echo "${diff_target_file_path}" \
			| sed 's/'${SED_TARGET_PAR_DIR_PATH}'/../' \
			| sed \
				-re 's/^(.*)/d_file2_path="\1"; diff_con=\$(colordiff -u  <(zcat  "\1") <(zcat  "'${SED_TARGET_PAR_DIR_PATH}''${sed_diff_target_file}'"))/' \
		) \
		<(\
			echo "${DFBK_DESK_CAT_FILE_CON}" \
			| sed \
				-r 's/(.*)/desk_con2=$(echo "[2] '${DESC_PREFIX}' \1")/'\
		) \
	| sed "s/$/\tdesk_con1=\"\$(echo \"[1] ${DESC_PREFIX} ${sed_diff_target_desk_con}\" | sed -r 's\/([^a-zA-Z0-9_])\/\\\\1\/g')\"/" \
	| sed -r 's/^(.*)\t(.*)\t(.*)$/\2;\3\;\1\ncase "${diff_con}" in "")\;\; \*) echo "\x1b[38;5;88m${desk_con2}\x1b[0m";echo "\x1b[38;5;88m[2] '\${d_file2_path}'\x1b[0m";echo "\x1b[38;5;2m${desk_con1}\x1b[0m";echo "\x1b[38;5;2m[1] ..'${sed_diff_target_file}'\x1b[0m";echo "${diff_con}";;esac/'
}