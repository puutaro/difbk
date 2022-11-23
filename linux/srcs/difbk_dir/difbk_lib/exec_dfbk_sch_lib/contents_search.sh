#!/bin/bash


CONTENTS_SEARCH_LIB_PATH="${EXEC_DFBK_SCH_LIB_PATH}/contents_search_lib"
. "${CONTENTS_SEARCH_LIB_PATH}/echo_target_merge_list.sh"
. "${CONTENTS_SEARCH_LIB_PATH}/echo_check_str.sh"
. "${CONTENTS_SEARCH_LIB_PATH}/echo_after_before.sh"
. "${CONTENTS_SEARCH_LIB_PATH}/echo_con_sch_con_in_contents_search.sh"
unset -v CONTENTS_SEARCH_LIB_PATH


contents_search(){
  local dfbk_exec_sch_file_path="${DFBK_SETTING_DIR_PATH}/exec_sch.sh"
  TARGET_MERGE_LIST=$(\
    echo_target_merge_list \
      "${j_option_janre}" \
      "${TARGET_MERGE_LIST}"\
  )
  local third_para_suffix="${C_OPTION:2:3}"
  local check_str=$(\
    echo_check_str \
      "${third_para_suffix}"\
  )
  local after_before=$(\
    echo_after_before \
      "${check_str}"\
  )
  DIFBK_SEARCH_WORD=$(\
    echo "${DIFBK_SEARCH_WORD}" \
      | sed \
        -r 's/([^a-zA-Z0-9\"_-])/\\\1/g'\
  )
  DFBK_DESK_CAT_FILE_CON=$(\
    desk_cat_func
  )
  local con_sch_con=$(\
    echo_con_sch_con_in_contents_search \
      "${j_option_janre}" \
      "${after_before}" \
  )
  eval "echo \"\${con_sch_con}\" ${desk_rga_cmd}  ${desk_rga_v_cmd}" ${before_and_after_delete_cmd} \
  | sed -e '/^$/d' -e '/^--$/d' \
    > "${dfbk_exec_sch_file_path}" \
    2>/dev/null
  local LANG="ja_JP.UTF-8" 
  bash "${dfbk_exec_sch_file_path}" \
  | less -XR
}
