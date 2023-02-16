#!/bin/bash

case "${RJ_OPTION}" in 
		"") 
			RJ_OPTION=1
			;;
esac
case "${RJ_OPTION}" in 
		"0") 
			exit 0
			;;
esac
E_OPTION="-e"
echo RJ_OPTION ${RJ_OPTION}
. "${DIFBK_DIR_PATH}/exec_dfbk_diff.sh"