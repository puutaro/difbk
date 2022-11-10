#!/bin.bash


differ_handler_when_no_relate_merge_list_lib_path="${EXEC_DIFBK_DIFF_LIB_PATH}/differ_handler_when_no_relate_merge_list_lib"
. "${differ_handler_when_no_relate_merge_list_lib_path}/read_diff_target_file.sh"
. "${differ_handler_when_no_relate_merge_list_lib_path}/echo_differ_paste_con_in_no_relate_merge_list.sh"

unset -v differ_handler_when_no_relate_merge_list_lib_path


differ_handler_when_no_relate_merge_list(){
	local second_para="${1}"
	local second_para_janre="${2}"
	case "${second_para_janre}" in
		"${JANRE_NO_RELATE_MERGE_LIST}") ;;
		*) return
	;;esac
	local dat_depth_path_con=$(\
		fd -IH -t d . ${BUCK_UP_DIR_PATH} -d 5 \
		| rga "[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}" \
		| sort -r\
	)
	local ifs_old="${IFS}"
	local IFS=$'\n'
	local DAY_DEPTH_PATH_LIST=($(echo ${dat_depth_path_con}))
	local RECENT_DAY_DEPTH_PATH_LIST=($(echo "${dat_depth_path_con}" | head -n 20))
	IFS="${ifs_old}"
	
	local diff_target_file=""
	read_diff_target_file \
		"${second_para}"

	local grep_path=$(\
		echo "${diff_target_file}" \
		| sed 's/^\/'${BUCK_UP_DIR_NAME}'\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/'${BACKUP_CREATE_DIR_NAME}'//'\
	)
	local sed_diff_target_file=$(\
		echo "${diff_target_file}" \
		| sed 's/\//\\\//g'\
	)
	local diff_target_desk_file=$(\
		echo "${diff_target_file}" \
		| sed \
			-e 's/^/\.\./' \
			-e "s/${BACKUP_CREATE_DIR_NAME}.*/${BUCKUP_DESC_FILE_NAME}/"\
	)
	local sed_diff_target_desk_con=$(\
		cat "${diff_target_desk_file}" \
			2>/dev/null \
		|| echo --\
	)
	local sed_diff_target_desk_con=$(\
		echo "${sed_diff_target_desk_con}" \
		| sed -r 's/([^a-zA-Z0-9_ ])/\\\1/g'\
	)
	local diff_target_file_path=$(\
		fd -IH . ${DAY_DEPTH_PATH_LIST[@]} \
		| rga "${grep_path}$" \
		| sort -r\
	)
	local TARGET_MERGE_LIST="${diff_target_file_path}"
	local DFBK_DESK_CAT_FILE_CON=$(\
		desk_cat_func \
			"${TARGET_MERGE_LIST}"\
	)
	local diff_paste_con=$(\
		echo_differ_paste_con_in_no_relate_merge_list \
			"${diff_target_file_path}" \
			"${sed_diff_target_file}" \
			"${DFBK_DESK_CAT_FILE_CON}"\
	)
	eval "echo \"\${diff_paste_con}\"${before_and_after_delete_cmd} ${desk_rga_cmd} ${desk_rga_v_cmd} " \
		| sed '/^--$/d' \
		> "${DFBK_EXEC_DIFF_PATH}"
	local LANG="ja_JP.UTF-8" 
	bash "${DFBK_EXEC_DIFF_PATH}"  \
		2>/dev/null  \
	| less -XR
	exit 0
}