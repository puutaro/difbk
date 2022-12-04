#!/bin/bash



exec_mk_label(){
	case "${MKLABEL_CON:-}" in 
		"") return
	;; esac
	if [ ! -e "${DFBK_LABEL_FILE_PATH}" ] \
		|| [ ! -s "${DFBK_LABEL_FILE_PATH}" ];then 
		echo "${MKLABEL_CON^^}" \
			> "${DFBK_LABEL_FILE_PATH}"
		LSLABEL_CON="${LSLABEL_ARGS}"
		exec_ls_label
		return
	fi
	local sed_mklabel_con=$(\
		echo "${MKLABEL_CON^^}" \
			| sed -r 's/([^a-zA-Z0-9_])/\\\1/g' \
	)
	sed "1i ${sed_mklabel_con}" \
		-i "${DFBK_LABEL_FILE_PATH}"
	wait
	LSLABEL_CON="${LSLABEL_ARGS}"
	exec_ls_label
}