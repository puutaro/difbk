#!/bin/bash


EXEC_DFBK_CLEAN_LIB_PATH="${DIFBK_LIB_DIR_PATH}/exec_dfbk_clean_lib"
. "${EXEC_DFBK_CLEAN_LIB_PATH}/validate_latest_merge_list.sh"
if [ -z "${LATEST_MERGE_LIST_VALIDATE_ARGS_OPTION}" ] \
	&& [ -z "${DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST}" ];then 
	echo "valid parater not found (${BUCKUP_CLEAN_ARGS_NAME} DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST:clean, ${LATEST_MERGE_LIST_VALIDATE_ARGS_NAME}: mergelist validation)"
	exit 0 ;
fi

validate_latest_merge_list \
	"${LATEST_MERGE_LIST_VALIDATE_ARGS_OPTION}"


. "${EXEC_DFBK_CLEAN_LIB_PATH}/end_by_check_delete_supper_order_num_for_merge_list.sh"
. "${EXEC_DFBK_CLEAN_LIB_PATH}/echo_registered_merge_file_paths_con.sh"
. "${EXEC_DFBK_CLEAN_LIB_PATH}/end_judge_for_clean_buckup.sh"
. "${EXEC_DFBK_CLEAN_LIB_PATH}/echo_day_depth_path_list.sh"
. "${EXEC_DFBK_CLEAN_LIB_PATH}/make_exec_clean_file_path.sh"
. "${EXEC_DFBK_CLEAN_LIB_PATH}/make_exec_clean_rmdir_path.sh"
. "${EXEC_DFBK_CLEAN_LIB_PATH}/make_exec_clean_rmdir_path.sh"


end_by_check_delete_supper_order_num_for_merge_list \
	"${DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST}"

DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST=$((${DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST} + 1))

registered_merge_file_paths_con=$(\
	echo_registered_merge_file_paths_con \
)

delete_supper_merge_list_path=$(\
	echo "${registered_merge_file_paths_con}" \
	| head -n 1 \
)
end_judge_for_clean_buckup \
	"${DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST}" \
	"${registered_merge_file_paths_con}" \
	"${delete_supper_merge_list_path}"

unset -v registered_merge_file_paths_con


delete_supper_merge_list_contents=$(\
	zcat ${delete_supper_merge_list_path} \
	| cut -f2\
)
day_depth_path_list=$(\
	echo_day_depth_path_list \
		"${delete_supper_merge_list_path}" \
)
IFS=$'\n'
day_depth_path_lists=($(echo "${day_depth_path_list}"))
IFS=$' \n'

EXEC_CLEAN_DIR_PATH="${DFBK_SETTING_DIR_PATH}/clean"
if [ ! -e "${EXEC_CLEAN_DIR_PATH}" ];then
	mkdir -p "${EXEC_CLEAN_DIR_PATH}"
fi
exec_clean_file_path="${EXEC_CLEAN_DIR_PATH}/exec_file_clean.sh"

CLEAN_FILE_NUM=""
make_exec_clean_file_path \
	"${exec_clean_file_path}" \
	"${day_depth_path_lists[@]}" \
	"${delete_supper_merge_list_contents}" &
make_exec_clean_file_path_pid=$!
wait_spin \
	"${make_exec_clean_file_path_pid}" \
	"difbk is culculating"
unset -v remove_when_exist_restore_target_dir_pid

echo "[1/2] file clean "
bash "${exec_clean_file_path}" | pv

make_exec_clean_rmdir_path \
	"${EXEC_CLEAN_DIR_PATH}"

echo " clean complete !"
