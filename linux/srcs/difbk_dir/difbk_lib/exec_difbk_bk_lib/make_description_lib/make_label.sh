#!/bin/bash


make_label(){
	case "${LN_OPTION}" in 
		"") ;;
		*) return ;;
	esac
	local label_con=$(\
		cat "${DFBK_LABEL_FILE_PATH}" \
	)
	case "${label_con}" in 
		"");;
		*)
			STAMP_LABEL="$(\
				bash \
					"${DIFBK_EXEC_LABEL_SELECT_FILE_PATH}" \
					"${DFBK_LABEL_FILE_PATH}" \
			)"
		;; 
	esac
}