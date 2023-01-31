#!/bin/bash


RS_BK_OPTION="${RS_BK_ARGS_NAME}"
case "${J_OPTION}" in 
	"") exit 0 ;;
esac

. "${DIFBK_DIR_PATH}/exec_dfbk_bk.sh"