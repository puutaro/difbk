#!/bin/bash


readonly DFBK_OUT_FD_LIST_FILE_PATH="${DFBK_SETTING_DIR_PATH}/out_fd_list.sh"
readonly DFBK_SCH_LIST_RECIEVE_DIR_PATH="${DFBK_SETTING_DIR_PATH}/sch_list_file_recieve"
readonly J_OPTION_WHEN_NO_MERGE_LIST_PATH=0
readonly J_OPTION_WHEN_MERGE_LIST_NUM=1
readonly J_OPTION_WHEN_MERGE_LIST_PATH=2

EXEC_DFBK_SCH_LIB_PATH="${DIFBK_LIB_DIR_PATH}/exec_dfbk_sch_lib"
. "${EXEC_DFBK_SCH_LIB_PATH}/end_when_j_option_arg_blank.sh"
. "${EXEC_DFBK_SCH_LIB_PATH}/echo_j_option_janre_by_how_merge_list_path.sh"
. "${EXEC_DFBK_SCH_LIB_PATH}/make_target_merge_list_and_path.sh"
. "${EXEC_DFBK_SCH_LIB_PATH}/make_rga_cmd.sh"
. "${EXEC_DFBK_SCH_LIB_PATH}/echo_target_merge_list_in_path_search.sh"
. "${EXEC_DFBK_SCH_LIB_PATH}/less_when_merge_list_path_or_num.sh"
. "${EXEC_DFBK_SCH_LIB_PATH}/less_when_no_merge_list_path_and_num.sh"
. "${EXEC_DFBK_SCH_LIB_PATH}/contents_search.sh"


readonly contents_search="-c"
contents_search_on=0
second_para="${2:-}"
third_para="${3:-}"
rm -rf "${DFBK_SCH_LIST_RECIEVE_DIR_PATH}"
mkdir "${DFBK_SCH_LIST_RECIEVE_DIR_PATH}"

RGA_OPTION=($(echo "${GENERAL_OPTION//\,/$'\t'}"))
j_option_arg=$(echo ${J_OPTION} | sed  's/-j//' | sed  's/^\s*//')
end_when_j_option_arg_blank \
	"${J_OPTION}" \
	"${j_option_arg}"
unset -v J_OPTION
j_option_janre=$(\
	echo_j_option_janre_by_how_merge_list_path \
	"${j_option_arg}" \
)
case "${C_OPTION::2}" in
	"") DIFBK_SEARCH_WORD+="${V_OPTION} ${O_OPTION}";;
	"${contents_search}") contents_search_on=1 ;;
esac

rga_after_num="1"
dRGA_OPTION=$(\
		echo ${dRGA_OPTION} \
		| sed  -re 's/-d([a-z]) /\ -\1\ /g' \
)
desk_rga_cmd=$(\
	echo_desk_rga_cmd \
		"${rga_after_num}"\
)
desk_rga_v_cmd=$(\
	echo_desk_rga_v_cmd \
		"${rga_after_num}"\
)

before_and_after_delete_cmd=$(\
	echo_before_and_after_delete_cmd \
		"${rga_after_num}" \
)
TARGET_MERGE_LIST=""
TARGET_MERGE_LIST_PATH=""
make_target_merge_list_and_path \
	"${j_option_janre}" \
	"${j_option_arg}"

# property serch word set -------------------------------------------------
case "${contents_search_on}" in 
	"1") 
		IFS=$'\t'
		DIFBK_SEARCH_WORD=($(echo ${DIFBK_SEARCH_WORD//\,/$'\t'} | sed  -r 's/([^a-zA-Z0-9_-])/\\\1/g'))
		IFS=$' \n'
		LANG="ja_JP.UTF-8" contents_search; exit 0;;
esac

RGA_CMD=""
RGA_CMD2=""
NO_SED_RGA_CMD=""
make_rga_cmd \
	"${DIFBK_SEARCH_WORD}"

TARGET_MERGE_LIST=$(\
	echo_target_merge_list_in_path_search \
		"${j_option_janre}"\
)
DFBK_DESK_CAT_FILE_CON=$(\
	desk_cat_func 
)

sed_target_par_path=$(\
	echo "${TARGET_PAR_DIR_PATH}" \
	| sed  -r 's/([^a-zA-Z0-9_])/\\\\\\\1/g'\
)
	echo "${DFBK_OUT_FD_LIST_FILE_PATH}"
less_when_merge_list_path_or_num \
	"${j_option_janre}" \
	"${RGA_CMD}" \
	"${RGA_CMD2}" \
	"${desk_rga_cmd}" \
	"${desk_rga_v_cmd}" \
	"${before_and_after_delete_cmd}"

less_when_no_merge_list_path_and_num \
	"${RGA_CMD}" \
	"${RGA_CMD2}" \
	"${sed_target_par_path}" \
	"${desk_rga_cmd}" \
	"${desk_rga_v_cmd}" \
	"${before_and_after_delete_cmd}"
