#!/bin/bash

readonly DFBK_EXEC_DIFF_PATH="${DFBK_SETTING_DIR_PATH}/DIFF.sh"


readonly CURRENT_TARGET_DIR_ORDER=1
readonly MERGE_LIST_SECONDS_ORDER=2
readonly JANRE_NO_RELATE_MERGE_LIST=0
readonly JANRE_MERGE_LIST_NUM=1
readonly JANRE_MERGE_LIST_PATH=2


EXEC_DIFBK_DIFF_LIB_PATH="${DIFBK_LIB_DIR_PATH}/exec_difbk_diff_lib"
. "${EXEC_DIFBK_DIFF_LIB_PATH}/echo_second_para_janre.sh"
. "${EXEC_DIFBK_DIFF_LIB_PATH}/echo_second_para.sh"
. "${EXEC_DIFBK_DIFF_LIB_PATH}/echo_recent_merge_list_path.sh"
. "${EXEC_DIFBK_DIFF_LIB_PATH}/end_when_recent_merge_list_path.sh"
. "${EXEC_DIFBK_DIFF_LIB_PATH}/echo_desk_rga_cmd_for_diff.sh"
. "${EXEC_DIFBK_DIFF_LIB_PATH}/echo_desk_rga_v_cmd_for_diff.sh"
. "${EXEC_DIFBK_DIFF_LIB_PATH}/differ_handler_when_no_relate_merge_list.sh"
. "${EXEC_DIFBK_DIFF_LIB_PATH}/echo_before_merge_list_path_for_diff.sh"
. "${EXEC_DIFBK_DIFF_LIB_PATH}/echo_diff_paste_con_generation.sh"
. "${EXEC_DIFBK_DIFF_LIB_PATH}/make_diff_file_pair_and_label_and_target_merge_list.sh"


unset -v DIFBK_BK_LIB_DIR_PATH


second_para=$(\
	echo_second_para\
		"${DIFBK_ARGUMENT}"
)

second_para_janre=$(\
	echo_second_para_janre \
		"${second_para}" \
)


recent_merge_list_path=$(\
	echo_recent_merge_list_path \
)

end_when_recent_merge_list_path \
	"${recent_merge_list_path}"

rga_after_num=1
dRGA_OPTION=$(\
	echo ${dRGA_OPTION} \
	| sed -re 's/-d([a-z]) /\ -\1\ /g'\
)
desk_rga_cmd=$(\
	echo_desk_rga_cmd_for_diff \
		"${D_OPTION}" \
		"${dRGA_OPTION}" \
		"${rga_after_num}" \
)
desk_rga_v_cmd=$(\
	echo_desk_rga_v_cmd_for_diff \
		"${DV_OPTION}" \
		"${rga_after_num}" \
)

before_and_after_delete_cmd=$(\
	echo_before_and_after_delete_cmd \
		${rga_after_num} \
		"diff" \
)

differ_handler_when_no_relate_merge_list \
	"${second_para}" \
	"${second_para_janre}" 


before_merge_list_path="$(\
	echo_before_merge_list_path_for_diff \
		"${second_para}" \
		"${second_para_janre}" \
)"


if [ ! -e "${recent_merge_list_path}" ];then 
	echo "no recent_merge_list_path: ${recent_merge_list_path}"
	exit 0
fi
if [ ! -e "${before_merge_list_path}" ] \
	&& [ "${second_para}" != "${CURRENT_TARGET_DIR_ORDER}" ];then 
	echo "no before_merge_list_path: ${before_merge_list_path}"
	exit 0
fi


case "${second_para}" in
	"${CURRENT_TARGET_DIR_ORDER}")
		CUR_DIFF_OPTION="${CUR_DIFF_ARGS_NAME}"
		DRY_BK_OPTION="${DRY_BK_ARGS_NAME}"
		. ${DIFBK_DIR_PATH}/exec_dfbk_bk.sh 
;;esac


sed_before_diff_label=""
diff_file_pair_con=""
TARGET_MERGE_LIST=""
make_diff_file_pair_and_label_and_target_merge_list \
	"${second_para}" \
	"${recent_merge_list_path}" \
	"${before_merge_list_path}"

DFBK_DESK_CAT_FILE_CON=$(\
	desk_cat_func \
		"${TARGET_MERGE_LIST}"\
)
unset -v TARGET_MERGE_LIST

diff_paste_con="$(
	echo_diff_paste_con_generation \
		"${sed_before_diff_label}" \
		"${diff_file_pair_con}" \
		"${DFBK_DESK_CAT_FILE_CON}" \
)"
eval "echo \"\${diff_paste_con}\"${before_and_after_delete_cmd}  ${desk_rga_cmd} ${desk_rga_v_cmd}" \
	| sed '/^--$/d' \
	> "${DFBK_EXEC_DIFF_PATH}"
LANG="ja_JP.UTF-8" 
bash "${DFBK_EXEC_DIFF_PATH}" \
	| less -XR
