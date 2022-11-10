#!/bin/bash


bash_merge_desk_files_for_mrg(){
	local sed_mrg_target_dir_name="${1}"
	local sed_mrg_buckup_dir_name="${2}"
	local merge_desc_cmd_path="${DFBK_SETTING_DIR_PATH}/mrg_merge_desc_cmd.sh"
	local bk_desc_file_paths=$(\
		echo "${BK_FILE_SRCS}" \
			| rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_DESC_FILE_NAME}"\
	)
	local bk_desc_file_dest_paths=$(\
		echo "${bk_desc_file_paths}" \
		| replace_desti_path \
			"${sed_mrg_target_dir_name}" \
			"${sed_mrg_buckup_dir_name}"\
	)
	paste \
		<(echo \
			"${bk_desc_file_paths}"\
		)  \
		<(\
			echo \
				"${bk_desc_file_dest_paths}"\
		) \
	| sed \
		-r 's/^(.*)\t(.*)$/src_desc="\.\.\1"\; deti_desc="'${dest_par_dir_path}'\2"\; \[ \-e "\$\{deti_desc\}" \] \&\& cat_src=\$\(paste \-d " " <(cat "\$\{src_desc\}") <(cat "\$\{deti_desc\}")\) \&\& echo "${cat_src}" \| tr \-d "\\n" \> "\$\{deti_desc\}" \|\| cp \-arvf "\$\{src_desc\}" "\$\{deti_desc\}" \&/' \
	| sed "$ a wait" \
		> "${merge_desc_cmd_path}"
	wait
	bash "${merge_desc_cmd_path}"
	wait
}