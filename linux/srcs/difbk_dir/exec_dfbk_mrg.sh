#!/bin/bash

readonly mrg_swich_on=1
readonly mrg_swich_off=0
opt_number=${mrg_swich_off}


EXEC_DFIBK_MRG_LIB_PATH="${DIFBK_LIB_DIR_PATH}/exec_dfbk_mrg_lib"
. "${EXEC_DFIBK_MRG_LIB_PATH}/echo_dest_par_dir_path_whether_blank.sh"
. "${EXEC_DFIBK_MRG_LIB_PATH}/end_judge_when_no_exist_mrg_target_dir_name.sh"
. "${EXEC_DFIBK_MRG_LIB_PATH}/replace_desti_path.sh"
. "${EXEC_DFIBK_MRG_LIB_PATH}/echo_update_mrg_target_dir_name.sh"
. "${EXEC_DFIBK_MRG_LIB_PATH}/echo_update_mrg_buckup_dir_name.sh"
. "${EXEC_DFIBK_MRG_LIB_PATH}/echo_bk_file_srcs_for_mrg.sh"
. "${EXEC_DFIBK_MRG_LIB_PATH}/bash_exec_mkdir_cmd_for_mrg.sh"
. "${EXEC_DFIBK_MRG_LIB_PATH}/bash_exec_cp_cmd_for_mrg.sh"
. "${EXEC_DFIBK_MRG_LIB_PATH}/bash_merge_desk_files_for_mrg.sh"
. "${EXEC_DFIBK_MRG_LIB_PATH}/bash_remake_merge_list_for_mrg.sh"


unset -v EXEC_DFIBK_MRG_LIB_PATH

dest_par_dir_path=$(\
	echo_dest_par_dir_path_whether_blank \
		"${DEST_PAR_DIR_NAME}"		
)

if [ -z "${MRG_TARGET_DIR_NAME}" ] \
	|| [ -z "${MRG_BUCKUP_DIR_NAME}" ]; then
	exit 0
fi

MRG_TARGET_DIR_NAME=$(\
	echo_update_mrg_target_dir_name \
	"${MRG_TARGET_DIR_NAME}"\
)


sed_mrg_target_dir_name="${MRG_TARGET_DIR_NAME//\//\\\/}"
case "${MRG_BUCKUP_DIR_NAME}" in 
	"-") 
		end_judge_when_no_exist_mrg_target_dir_name \
			"${MRG_TARGET_DIR_NAME}"
		;;
esac
MRG_BUCKUP_DIR_NAME=$(\
	echo_update_mrg_buckup_dir_name \
		"${MRG_TARGET_DIR_NAME}" \
		"${MRG_BUCKUP_DIR_NAME}" \
)

sed_mrg_buckup_dir_name="${MRG_BUCKUP_DIR_NAME//\//\\\/}"

bash_exec_mkdir_cmd_for_mrg \
	"${sed_mrg_target_dir_name}" \
	"${sed_mrg_buckup_dir_name}" \
	"${dest_par_dir_path}" &
bash_exec_mkdir_cmd_pid=$! 
wait_spin \
	"${bash_exec_mkdir_cmd_pid}" \
	"[1/4] mkdir process"
unset -v bash_exec_mkdir_cmd_pid


BK_FILE_SRCS=$(\
	echo_bk_file_srcs_for_mrg \
)
BK_FILE_PATHS=$(\
	echo "${BK_FILE_SRCS}" \
	| rga \
		-v "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_DESC_FILE_NAME}"\
)

BK_FILE_DEST_PATHS=$(\
	echo "${BK_FILE_PATHS}" \
	| replace_desti_path \
		"${sed_mrg_target_dir_name}" \
		"${sed_mrg_buckup_dir_name}"\
)

bash_exec_cp_cmd_for_mrg \
	"${dest_par_dir_path}" \
	"${BK_FILE_PATHS}" \
	"${BK_FILE_DEST_PATHS}" &

bash_bash_exec_cp_cmd_for_mrg_pid=$! 
wait_spin \
	"${bash_bash_exec_cp_cmd_for_mrg_pid}" \
	"[2/4] cp file process"
unset -v bash_bash_exec_cp_cmd_for_mrg_pid


bash_merge_desk_files_for_mrg \
	"${sed_mrg_target_dir_name}" \
	"${sed_mrg_buckup_dir_name}" \
	"${BK_FILE_SRCS}" &
bash_exec_cp_cmd_for_mrg_pid=$! 
wait_spin \
	"${bash_exec_cp_cmd_for_mrg_pid}" \
	"[3/4] merge desk file process"
unset -v bash_exec_cp_cmd_for_mrg_pid

bash_remake_merge_list_for_mrg \
	"${sed_mrg_target_dir_name}" \
	"${sed_mrg_buckup_dir_name}" \
	"${dest_par_dir_path}" \
	"${BK_FILE_DEST_PATHS}"
bash_remake_merge_list_for_mrg_pid=$! 
wait_spin \
	"${bash_remake_merge_list_for_mrg_pid}" \
	"[3/4] remake merge lists process"
unset -v bash_remake_merge_list_for_mrg_pid
