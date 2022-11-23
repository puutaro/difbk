#!/bin/bash


less_when_no_merge_list_path_and_num_lib_path="${EXEC_DFBK_SCH_LIB_PATH}/less_when_no_merge_list_path_and_num_lib"
. "${less_when_no_merge_list_path_and_num_lib_path}/echo_sch_paste_con_when_no_merge_list_path_and_num.sh"
unset -v less_when_no_merge_list_path_and_num_lib_path


less_when_no_merge_list_path_and_num(){
	local RGA_CMD="${1}"
	local RGA_CMD2="${2}"
	local sed_target_par_path="${3}"
	local desk_rga_cmd="${4}"
	local desk_rga_v_cmd="${5}"
	local before_and_after_delete_cmd="${6}"
	local sch_paste_con=$(\
		echo_sch_paste_con_when_no_merge_list_path_and_num \
			"${RGA_CMD}" \
			"${RGA_CMD2}" \
			"${sed_target_par_path}" \
	) 
	eval "echo \"\${sch_paste_con}\" ${before_and_after_delete_cmd} ${desk_rga_cmd} ${desk_rga_v_cmd} " \
	| sed  '/^--$/d' \
		> "${DFBK_OUT_FD_LIST_FILE_PATH}"
	wait 
	local LANG="ja_JP.UTF-8" 
	bash "${DFBK_OUT_FD_LIST_FILE_PATH}"  | less -XR
}