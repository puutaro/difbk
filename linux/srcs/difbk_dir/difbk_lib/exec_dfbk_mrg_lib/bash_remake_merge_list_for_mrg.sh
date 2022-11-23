#!/bin/bash


bash_remake_merge_list_for_mrg(){
	local sed_mrg_target_dir_name="${1}"
	local sed_mrg_buckup_dir_name="${2}"
	local dest_par_dir_path="${3}"
	local remake_mrg_ls_cmd_path="${DFBK_SETTING_DIR_PATH}/remake_mrg_ls_cmd.sh"
	cat <(\
		echo 'sed_mrg_target_dir_name='${sed_mrg_target_dir_name}';sed_mrg_buckup_dir_name='${sed_mrg_buckup_dir_name}'; replace_desti_path(){ cat "/dev/stdin"  | sed -r "s/^(\/'${BUCK_UP_DIR_NAME}'\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/'${BACKUP_CREATE_DIR_NAME}')\/'${TARGET_DIR_NAME}'/\1\/${1}/" | sed "s/\/\//\//g" | sed "s/^\/'${BUCK_UP_DIR_NAME}'/\/${2}/";}'\
	) \
	<(\
		echo "${BK_FILE_DEST_PATHS}" \
		| rga "^/${MRG_BUCKUP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" \
		| sed \
			-r 's/(.*)/mrg_ls_path="'${dest_par_dir_path}'\1" \&\& mrg_ls_con\=\$(zcat "\$\{mrg_ls_path\}"\) \&\& paste \<\(echo "\$\{mrg_ls_con\}"\)  \<\(echo "\$\{mrg_ls_con\}" \| cut \-f2  \| replace_desti_path "\$\{sed_mrg_target_dir_name\}" "\$\{sed_mrg_buckup_dir_name\}"\) \| sed -r "s\/^\(\.\*\)\\t\(\.\*\)\\t\(\.\*\)\$\/\\1\\t\\3\/" \| gzip -c \> "\$\{mrg_ls_path\}" \&/'\
	) \
	| sed "$ a wait" \
		> "${remake_mrg_ls_cmd_path}"
	wait
	bash "${remake_mrg_ls_cmd_path}"
	wait
}