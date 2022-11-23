#!/bin/bash


LESS_WHEN_MERGE_LIST_PATH_OR_NUM_LIB_PATH="${EXEC_DFBK_SCH_LIB_PATH}/less_when_merge_list_path_or_num_lib"
. "${LESS_WHEN_MERGE_LIST_PATH_OR_NUM_LIB_PATH}/sed_target_desk_con.sh"
. "${LESS_WHEN_MERGE_LIST_PATH_OR_NUM_LIB_PATH}/echo_sch_paste_con_merge_list_path_or_num.sh"
. "${LESS_WHEN_MERGE_LIST_PATH_OR_NUM_LIB_PATH}/make_out_fd_list_file.sh"
unset -v LESS_WHEN_MERGE_LIST_PATH_OR_NUM_LIB_PATH


less_when_merge_list_path_or_num(){
	local j_option_janre="${1}"
	local RGA_CMD="${2}"
	local RGA_CMD2="${3}"
	local desk_rga_cmd="${4}"
	local desk_rga_v_cmd="${5}"
	local before_and_after_delete_cmd="${6}"

	case "${j_option_janre}" in 
	"${J_OPTION_WHEN_MERGE_LIST_NUM}"|"${J_OPTION_WHEN_MERGE_LIST_PATH}") ;;
	*) return
	;; esac
	local sed_target_desk_con=$(\
		sed_target_desk_con
	)
	local sch_paste_con="$(
		echo_sch_paste_con_merge_list_path_or_num \
			"${RGA_CMD2}" \
			"${sed_target_desk_con}" \
	)"
	make_out_fd_list_file \
		"${desk_rga_cmd}" \
		"${desk_rga_v_cmd}" \
		"${before_and_after_delete_cmd}"
	local LANG="ja_JP.UTF-8"
	bash "${DFBK_OUT_FD_LIST_FILE_PATH}" \
		2>/dev/null \
	| less -XR
	exit 0
}