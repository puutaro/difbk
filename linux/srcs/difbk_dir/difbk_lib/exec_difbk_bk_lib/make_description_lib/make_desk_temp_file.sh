#!/bin/bash


make_desk_temp_file(){
	local stamp_label="${1}"
	case "${BK_DESK_CONTENTS:-}" in 
		"")
			[ -n "${stamp_label}" ] \
				&& echo "${stamp_label}" \
				> ${BUCKUP_DESC_TEMP_FILE_PATH} \
			|| e=$?
			echo "${stamp_label}" \
				> ${BUCKUP_DESC_TEMP_FILE_PATH}
			echo "${stamp_label}" > ${BUCKUP_DESC_TEMP_FILE_PATH}
			nano ${BUCKUP_DESC_TEMP_FILE_PATH};;
		*) 	
			[ -z "${stamp_label}" ] \
			&& echo "${BK_DESK_CONTENTS}" \
				> "${BUCKUP_DESC_TEMP_FILE_PATH}" \
			&& return \
			|| e=$?
			local sed_stamp_label=$(\
				echo "${stamp_label}" \
				| sed -r 's/([^a-zA-Z0-9_])/\\\1/g' \
			)
			BK_DESK_CONTENTS=$(\
				echo "${BK_DESK_CONTENTS}" \
				| sed "1s/^/${sed_stamp_label}/" \
			)
			echo "${BK_DESK_CONTENTS}" \
				> "${BUCKUP_DESC_TEMP_FILE_PATH}"
			;;
	esac
}