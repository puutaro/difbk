#!/bin/bash


make_out_fd_list_file(){
	local desk_rga_cmd="${1}"
	local desk_rga_v_cmd="${2}"
	local before_and_after_delete_cmd="${3}"

	eval "echo \"\${sch_paste_con}\" ${before_and_after_delete_cmd} ${desk_rga_cmd} ${desk_rga_v_cmd}" \
	| sed  '/^--$/d' \
		> "${DFBK_OUT_FD_LIST_FILE_PATH}"
	wait
}