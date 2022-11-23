#!/bin/bash


bash_exec_cp_cmd_for_mrg(){
	local dest_par_dir_path="${1}"
	local cp_cmd_path="${DFBK_SETTING_DIR_PATH}/mrg_cp_cmd.sh"
	paste \
		<(\
			echo "${BK_FILE_PATHS}"\
		)  \
		<(\
			echo "${BK_FILE_DEST_PATHS}"\
		) \
	| sed \
		-r 's/^(.*)\t(.*)$/cp -avf "\.\.\1" "'${dest_par_dir_path}'\2" \&/' \
	| sed "$ a wait" \
		> "${cp_cmd_path}"
	wait
	bash "${cp_cmd_path}"
	wait
}