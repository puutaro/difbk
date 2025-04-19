#!/bin/bash


echo_target_merge_list(){
	local j_option_janre="${1}"
	case "${j_option_janre}" in 
    "${J_OPTION_WHEN_NO_MERGE_LIST_PATH}")
      	fd -IH -t d . ${BUCK_UP_DIR_PATH} \
      		--max-depth 5 \
          | rga "${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}[/]*$" \
          | sort -r\
    	;;
    "${J_OPTION_WHEN_MERGE_LIST_PATH}")
      echo "${TARGET_MERGE_LIST}" \
        | sed \
           -r 's/(.*)/..\1'${DFBK_GGIP_EXETEND}'/'
    	;;
    "${J_OPTION_WHEN_MERGE_LIST_NUM}")
		echo "${TARGET_MERGE_LIST}"
		;;
  esac
}