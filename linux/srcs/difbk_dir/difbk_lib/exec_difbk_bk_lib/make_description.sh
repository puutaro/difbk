#!/buin/bash


make_description_lib_path="${DIFBK_BK_LIB_DIR_PATH}/make_description_lib"
. "${make_description_lib_path}/make_label.sh"
. "${make_description_lib_path}/make_desk_temp_file.sh"

unset -v make_description_lib_path


make_description(){
	case "${DRY_BK_OPTION}" in
		"");;
		*) return
	esac
	case "${DN_OPTION}" in 
		"") ;;
		*) 	echo ""
			return
	;; esac
	if [ -e "${BUCKUP_DESC_FILE_PATH}" ];then 
		local before_desc_contents=$(\
			cat "${BUCKUP_DESC_FILE_PATH}" \
		)
		cp \
			"${BUCKUP_DESC_FILE_PATH}" \
			"${BUCKUP_DESC_TEMP_FILE_PATH}"
	fi
	local STAMP_LABEL=""
	make_label
	make_desk_temp_file \
		"${STAMP_LABEL}"
	if [ ! -e "${BUCKUP_DESC_TEMP_FILE_PATH}" ] \
		|| [ -z "$(\
				cat "${BUCKUP_DESC_TEMP_FILE_PATH}" \
					| sed 's/\s//g' \
					| sed '/^$/d' \
				)" \
		]; then exit 0 ;fi
	if [ -e "${BUCKUP_DESC_TEMP_FILE_PATH}" ];then
		AFTER_DESC_CONTENTS="$(\
			cat "${BUCKUP_DESC_TEMP_FILE_PATH}" \
		)"
	fi
	if [ \
			"$(echo "${before_desc_contents:-}")" \
				== "$(echo "${AFTER_DESC_CONTENTS:-}")" \
		];then exit 0;fi
}