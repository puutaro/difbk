#!/bin/bash


bash_exec_mkdir_cmd_for_mrg(){
	local sed_mrg_target_dir_name="${1}"
	local sed_mrg_buckup_dir_name="${2}"
	local dest_par_dir_path="${3}"
	local bk_dir_paths=$(\
		fd -IH -t d \
			. "${BUCK_UP_DIR_PATH}" \
			| sed "s/^${SED_TARGET_PAR_DIR_PATH}//" \
			| sort -r\
	)
	
	local mkdir_cmd_path="${DFBK_SETTING_DIR_PATH}/mrg_mkdir_cmd.sh"
	echo "${bk_dir_paths}" \
		| replace_desti_path \
			"${sed_mrg_target_dir_name}" \
			"${sed_mrg_buckup_dir_name}" \
		| sed \
			-r 's/(.*)/mkdir -p "'${dest_par_dir_path}'\1" \&/' \
		| sed "$ a wait" \
		> "${mkdir_cmd_path}"
	wait
	bash "${mkdir_cmd_path}"
	wait
}