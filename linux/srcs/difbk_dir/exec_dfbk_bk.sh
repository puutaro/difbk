#!/bin/bash


readonly DFBK_UTIL_DIR_NAME=".difbk"
readonly DFBK_UTIL_DIR_PATH="${TARGET_DIR_PATH}/${DFBK_UTIL_DIR_NAME}"
readonly DFBK_LABEL_DIR_NAME="difbk_label"
readonly DFBK_LABEL_DIR_PATH="${DFBK_UTIL_DIR_PATH}/${DFBK_LABEL_DIR_NAME}"
readonly DFBK_LABEL_FILE_NAME="difbk_label_list"
readonly DFBK_LABEL_FILE_PATH="${DFBK_LABEL_DIR_PATH}/${DFBK_LABEL_FILE_NAME}"
readonly DFBK_CUR_FD_CON_FILE_PATH="${DFBK_SETTING_DIR_PATH}/cr_fd_con.sh"
readonly DFBK_CHECK_SUM_CULC_DIR_PATH="${DFBK_SETTING_DIR_PATH}/checksum_culc"
readonly DFBK_CHECK_SUM_OUTPUT_FILE_PATH="${DFBK_SETTING_DIR_PATH}/checksum_output"
readonly DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH="${DFBK_SETTING_DIR_PATH}/checksum_output_receive"
readonly BUCKUP_DESC_TEMP_FILE_PATH="${DFBK_SETTING_DIR_PATH}/${BUCKUP_DESC_FILE_NAME}"

readonly SED_DFBK_CHECK_SUM_CULC_DIR_PATH="${DFBK_CHECK_SUM_CULC_DIR_PATH//\//\\\/}"
readonly SED_DFBK_CHECK_SUM_OUTPUT_FILE_PATH="${DFBK_CHECK_SUM_OUTPUT_FILE_PATH//\//\\\/}"
readonly SED_DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH="${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH//\//\\\/}"

DIFBK_BK_LIB_DIR_PATH="${DIFBK_LIB_DIR_PATH}/exec_difbk_bk_lib"
. "${DIFBK_BK_LIB_DIR_PATH}/label.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/init.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/checksum_calc_and_write_out_to_file.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/get_buckup_con_from_recent_merge_con.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/make_description.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/echo_ls_current_dir_contents.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/echo_removed_path_to_create_bauckup_dir.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/substitute_common_con_by_marging_two.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/insert_row_path_from_contents.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/display_bk_result.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/exec_no_buck_up_exit.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/echo_merge_list_file_path.sh"
. "${DIFBK_BK_LIB_DIR_PATH}/exec_bk_and_rbk_handler.sh"


unset -v DIFBK_BK_LIB_DIR_PATH


init
label
checksum_calc_and_write_out_to_file &
checksum_calc_and_write_out_to_file_pid=$! 

merge_list_file_path=$(\
	echo_merge_list_file_path \
		"${J_OPTION}"
)

case "${merge_list_file_path}" in
	"") 
		echo "merge list path or number invalid"
		exit 0
		;;
esac

LS_BUCKUP_MERGE_CONTENTS=""
get_buckup_con_from_recent_merge_con \
	"${merge_list_file_path}"
AFTER_DESC_CONTENTS=""
make_description
wait_spin \
	"${checksum_calc_and_write_out_to_file_pid}" \
	"difbk is culclating"
unset -v checksum_calc_and_write_out_to_file_pid
ls_current_dir_contents=$(\
	echo_ls_current_dir_contents \
)
rm -rf "${DFBK_CHECK_SUM_CULC_DIR_PATH}" && 
mkdir -p "${DFBK_CHECK_SUM_CULC_DIR_PATH}" &
rm -rf  "${DFBK_CHECK_SUM_CULC_DIR_PATH}" \
		"${DFBK_CHECK_SUM_OUTPUT_FILE_PATH}" \
		"${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH}" &

ls_backup_dir_c_for_diff=$(\
	echo_removed_path_to_create_bauckup_dir \
		"${LS_BUCKUP_MERGE_CONTENTS}"
)

LS_CREATE_BUCKUP_MERGE_CONTENTS=""
LS_DELETE_BUCKUP_MERGE_CONTENTS=""
substitute_unique_con_by_comparing_two \
	"${ls_current_dir_contents}" \
	"${ls_backup_dir_c_for_diff}" 

unset -v ls_current_dir_contents
unset -v ls_backup_dir_c_for_diff


LS_BUCKUP_MERGE_CONTENTS=$(\
	substitute_common_con_by_marging_two \
		"${LS_BUCKUP_MERGE_CONTENTS}" \
		"${LS_DELETE_BUCKUP_MERGE_CONTENTS}" \
)

LS_BUCKUP_MERGE_CONTENTS=$(\
	substitute_common_con_by_marging_two \
		"${LS_BUCKUP_MERGE_CONTENTS}" \
		"${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
)

LS_BUCKUP_MERGE_CONTENTS="$(\
	insert_row_path_from_contents \
		"${LS_BUCKUP_MERGE_CONTENTS}"  \
		"${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
)"


no_restore_message="no restore buckup target file"
exec_no_buck_up_exit \
	"${RS_BK_OPTION}" \
	"${no_restore_message}" \
	"${LS_CREATE_BUCKUP_MERGE_CONTENTS}"

exec_bk_and_rbk_handler \
	"${RS_BK_OPTION}" \
	"${merge_list_file_path}" \
	"${LS_DELETE_BUCKUP_MERGE_CONTENTS}" \
	"${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
	"${LS_BUCKUP_MERGE_CONTENTS}"


display_bk_result \
	"${merge_list_file_path}" \
	"${no_restore_message}" \
	"${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
	"${LS_DELETE_BUCKUP_MERGE_CONTENTS}"


case "${CUR_DIFF_OPTION}" in
	"");;
	*) echo "${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
			> "${DFBK_CREATE_CON_PATH}"
;; esac