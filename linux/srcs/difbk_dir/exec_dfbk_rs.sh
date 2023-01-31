#!/bin/bash

readonly DFBK_RESTORE_DIR_PATH="${DFBK_SETTING_DIR_PATH}/restore"
file_path_with_merge_or_gip="${DIFBK_ARGUMENT_LIST[0]}"
restore_target_dir_path="${DIFBK_ARGUMENT_LIST[1]:-}"
grep_path_source_against_merge_list="${DIFBK_ARGUMENT_LIST[2]:-}"

EXEC_DFBK_RS_LIB_PATH="${DIFBK_LIB_DIR_PATH}/exec_dfbk_rs_lib"
. "${EXEC_DFBK_RS_LIB_PATH}/echo_restore_target_file_source_path.sh"
. "${EXEC_DFBK_RS_LIB_PATH}/handler_for_file_restore.sh"


restore_target_file_source_path=$(\
	echo_restore_target_file_source_path\
		"${file_path_with_merge_or_gip}"\
)
handler_for_file_restore\
	"${restore_target_file_source_path}" \
	"${restore_target_dir_path}"


. "${EXEC_DFBK_RS_LIB_PATH}/echo_exist_merge_list_path.sh"
. "${EXEC_DFBK_RS_LIB_PATH}/end_judge_by_merge_list_path_and_restore_target_dir_path.sh"
. "${EXEC_DFBK_RS_LIB_PATH}/echo_ls_buckup_merge_contents.sh"
. "${EXEC_DFBK_RS_LIB_PATH}/remove_when_exist_restore_target_dir.sh"
unset -v EXEC_DFBK_RS_LIB_PATH

exist_merge_list_path=$(\
	echo_exist_merge_list_path \
		"${file_path_with_merge_or_gip}"\
)

end_judge_by_merge_list_path_and_restore_target_dir_path \
	"${exist_merge_list_path}" \
	"${restore_target_dir_path}"

echo " wait restore culc" 
LS_BUCKUP_MERGE_CONTENTS=$(\
	echo_ls_buckup_merge_contents\
		"${exist_merge_list_path}"\
		"${grep_path_source_against_merge_list}"\
)
case "${LS_BUCKUP_MERGE_CONTENTS}" in
	"") echo "no exist for restore contents"
		return 
;; esac
remove_when_exist_restore_target_dir \
	"${restore_target_dir_path}"
copy_and_unzip \
	"${restore_target_dir_path}" \
	"${LS_BUCKUP_MERGE_CONTENTS}"
wait
echo "total: $(\
		echo "${LS_BUCKUP_MERGE_CONTENTS}" \
		| wc -l \
		| sed 's/\ //g'\
	)"
