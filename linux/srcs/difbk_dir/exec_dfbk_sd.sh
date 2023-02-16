#!/bin/bash

case "${J_OPTION}" in 
		"") 
			J_OPTION=1
			;;
esac
case "${J_OPTION}" in 
		"0") 
			exit 0
			;;
esac

E_OPTION="-e"
. "${DIFBK_DIR_PATH}/exec_dfbk_diff.sh"