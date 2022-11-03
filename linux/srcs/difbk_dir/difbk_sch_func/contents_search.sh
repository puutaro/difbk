#!/bin/bash

contents_search(){
  case "${j_option_janre}" in 
    "0")
      # target_merge_list: DAY_DEPTH_PATH_LIST
      target_merge_list=$(fd -IH -t d . ${BUCK_UP_DIR_PATH} --max-depth 5 |rga "${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}$" | sort -r);;
  esac

  third_para_suffix="${C_OPTION:2:3}"
  case "${third_para_suffix}" in 
    "") check_str="nasi";;
    *) check_str=$(echo "${third_para_suffix//[0-9]/}");;
  esac 
  after_before=""
  case "${check_str}" in 
    "") after_before="-A ${third_para_suffix} -B ${third_para_suffix}";;
  esac
  DIFBK_SEARCH_WORD=$(echo "${DIFBK_SEARCH_WORD}" | sed -r 's/([^a-zA-Z0-9\"_-])/\\\1/g')
  DFBK_DESK_CAT_FILE_CON=$(desk_cat_func "${target_merge_list}")
  case "${j_option_janre}" in 
    "0")
        # make contents file ----------------------------------------------------
        local con_sch_con=$(paste <(echo "${target_merge_list}" | sed -re "s/^(.*)/rga_con=\$(rga  -n  --heading ${RGA_OPTION[@]}  ${after_before} --color=ansi  --colors 'path:fg:22' --colors 'match:fg:21' \"${DIFBK_SEARCH_WORD}\" \"\1\")\; case \"\${rga_con}\" in \"\")\;\; \*) echo \"\x1b[1;38;5;2m\${desk_con}\x1b[0m\"\; echo \"\${rga_con}\"\;\;esac /" | sed -r "s/(.*)/ \1/") <(echo "${DFBK_DESK_CAT_FILE_CON}" | sed -r 's/(.*)/desk_con="'${DESC_PREFIX}' \1"/') | sed -r 's/(.*)\t(.*)/\2\n\1/')
        ;;
    "1"|"2")
        local sed_target_desk_con=$(cat "$(echo "${target_merge_list_path}" | sed  -e "s/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}.*/${BUCKUP_DESC_FILE_NAME}/")" | sed -r 's/(.*)/(\1)/' | sed -r 's/([^a-zA-Z0-9_])/\\\1/g')
        # make contents file ----------------------------------------------------
        local con_sch_con=$(paste <(echo "${target_merge_list}" | sed -re "s/^(.*)/rga_con=\$(rga  -n  --heading ${RGA_OPTION[@]}  ${after_before} --color=ansi  --colors 'path:fg:22' --colors 'match:fg:21' \"${DIFBK_SEARCH_WORD}\" \"\1\")\; case \"\${rga_con}\" in \"\")\;\; \*) echo \"\x1b[38;5;29m${sed_target_desk_con}\x1b[0m\"\; echo \"\x1b[38;5;2m\${desk_con}\x1b[0m\"\; echo \"\x1b[38;5;22m\1\x1b[0m\"\; echo \"\${rga_con}\"\;\;esac /" | sed -r "s/(.*)/target_desk_con=\$(echo \"${sed_target_desk_con}\"); \1/") <(echo "${DFBK_DESK_CAT_FILE_CON}" | sed -r 's/(.*)/desk_con="'${DESC_PREFIX}' \1"/') | sed -r 's/(.*)\t(.*)/\2\n\1/')
        # make desk cat file ----------------------------------------------------
  esac
  eval "echo \"\${con_sch_con}\" ${desk_rga_cmd}  ${desk_rga_v_cmd}" ${before_and_after_delete_cmd} | sed -e '/^$/d' -e '/^--$/d' > "${DFBK_EXEC_SCH_FILE_PATH}" 2>/dev/null
  LANG="ja_JP.UTF-8" bash "${DFBK_EXEC_SCH_FILE_PATH}"  | less -XR
}
