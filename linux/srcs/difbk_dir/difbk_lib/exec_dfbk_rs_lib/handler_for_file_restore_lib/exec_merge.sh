#!/bin/bash


exec_merge(){
	local path_by_deflosting_restore_target_file="${1}"
	local restore_target_file_path="${2}"
	local merge_cat_path="${DFBK_RESTORE_DIR_PATH}/merge_contents.txt"
	merge -p -A \
		"${path_by_deflosting_restore_target_file}" \
		"${restore_target_file_path}" \
		"${path_by_deflosting_restore_target_file}" \
		> ${merge_cat_path} || e=$?
	wait
	cat "${merge_cat_path}" \
		> "${restore_target_file_path}"
	wait
	rm \
		"${path_by_deflosting_restore_target_file}" \
		"${merge_cat_path}"
}