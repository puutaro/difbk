#!/bin/bash

DFBK_LABEL_FILE_PATH="${1}"
DFBL_ALL_LABEL_DELETE="CURRENTLABEL_DELETE"
stamp_label_con=""
[ -f "${HOME}/.fzf.bash" ] && . ${HOME}/.fzf.bash
while true : 
do
	labal_con=$(cat "${DFBK_LABEL_FILE_PATH}")
	current_label=$(echo "${stamp_label_con}" | sed -r 's/([^a-zA-Z0-9_])/\\\1/g')
	case "${current_label}" in "") current_label="-";;esac
	read stamp_label < <(echo "${labal_con}" | sed "1i ${current_label}" \
		| sed "$ a ${DFBL_ALL_LABEL_DELETE}" \
		| fzf --cycle --header-lines=1 --color 'fg:#000000,fg+:#ddeeff,bg:#f2f2f2,preview-bg:#e6ffe6,border:#ffffff'\
            --color 'info:#00b386,hl+:#02ebc7,hl:#0750fa,header:#000000,gutter:#000000' \
            --color 'marker:#0750fa,spinner:#0750fa,pointer:#00b386,prompt:#000000')
	status_code=$?
	case "${stamp_label}" in "");;  
		"${DFBL_ALL_LABEL_DELETE}")
			stamp_label_con="" ;;
		*) 
			if [ $(echo "${labal_con}" | wc -l) -gt 1 ];then
				label_con=$(echo "${labal_con}" | sed "/^${stamp_label}$/d" | sed "1i ${stamp_label}")
				echo "${label_con}" > "${DFBK_LABEL_FILE_PATH}"
			fi
			stamp_label_con+=$(echo "[${stamp_label}] ") ;; esac
	[ ${status_code} -eq 1 ] && break
done << END
$STR
END
echo "${stamp_label_con}"