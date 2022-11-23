#!/bin/bash


exec_ls_label(){
	case "${LSLABEL_CON:-}" in 
		"") return 
	;; esac
	local LANG="ja_JP.UTF-8" 
	echo "# your created label list"
	cat "${DFBK_LABEL_FILE_PATH}"
	exit 0
}