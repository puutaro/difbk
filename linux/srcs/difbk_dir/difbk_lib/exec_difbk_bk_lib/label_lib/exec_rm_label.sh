#!/bin/bash



exec_rm_label(){
	case "${RMLABEL_CON:-}" in 
		"") return 
	;; esac
	local sed_rmlabel_con=$(\
		echo "${RMLABEL_CON^^}" \
			| sed -r 's/([\\])/\\\\\\\1/g' \
			| sed -r "s/([^a-zA-Z0-9_'\#\)\(\|\{\}\+\;\:\<\>])/\\\\\1/g" \
	)
	local rm_after_con=$(\
		cat "${DFBK_LABEL_FILE_PATH}" \
			| sed "s/^${sed_rmlabel_con}$//g" \
			| sed '/^$/d' \
	) 
	echo "${rm_after_con}" \
		> "${DFBK_LABEL_FILE_PATH}"
	wait
	LSLABEL_CON="${LSLABEL_ARGS}"
	exec_ls_label
}