#!/bin/bash


echo_sch_con_when_merge_list_in_con_sch(){
	local after_before="${1}"
	local sed_target_desk_con=$(\
        cat "$(\
          echo "${TARGET_MERGE_LIST_PATH}" \
          | sed  \
            -e "s/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}.*/${BUCKUP_DESC_FILE_NAME}/")" \
          | sed \
              -r 's/(.*)/(\1)/' \
          | sed \
              -r 's/([^a-zA-Z0-9_])/\\\1/g'\
    )
    paste \
      <(\
        echo "${TARGET_MERGE_LIST}" \
        | sed -re "s/^(.*)/rga_con=\$(rga -z -a -n --heading ${RGA_OPTION[@]}  ${after_before} --color=ansi --colors 'path:fg:22' --colors 'match:fg:21' \"${DIFBK_SEARCH_WORD}\" \"\1\")\; case \"\${rga_con}\" in \"\")\;\; \*) echo \"\x1b[38;5;29m${sed_target_desk_con}\x1b[0m\"\; echo \"\x1b[38;5;2m\${desk_con}\x1b[0m\"\; echo \"\x1b[38;5;22m\1\x1b[0m\"\; echo \"\${rga_con}\"\;\;esac /" \
        | sed -r "s/(.*)/target_desk_con=\$(echo \"${sed_target_desk_con}\"); \1/"\
      ) \
      <(\
        echo "${DFBK_DESK_CAT_FILE_CON}" \
        | sed \
          -r 's/(.*)/desk_con="'${DESC_PREFIX}' \1"/'\
      ) \
    | sed \
      -r 's/(.*)\t(.*)/\2\n\1/'
}