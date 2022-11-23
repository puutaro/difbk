#!/bin/bash


handler_for_file_restore_lib_path="${EXEC_DFBK_RS_LIB_PATH}/handler_for_file_restore_lib"
. "${handler_for_file_restore_lib_path}/make_restore_target_file_path.sh"
. "${handler_for_file_restore_lib_path}/exec_merge.sh"
unset -v handler_for_file_restore_lib_path


handler_for_file_restore(){
	local restore_target_file_source_path="${1}"
	local restore_target_dir_path="${2}"
	case "${restore_target_file_source_path}" in
	"") return 
		;;
	esac
	rm -rf "${DFBK_RESTORE_DIR_PATH}" \
	&& mkdir -p "${DFBK_RESTORE_DIR_PATH}"
	local path_by_deflosting_restore_target_file="${DFBK_RESTORE_DIR_PATH}/$(echo "${restore_target_file_source_path}" | sed -e 's/^\.\.//' -re "s/([^a-zA-Z0-9_-])/_/g")"
	zcat "${restore_target_file_source_path}" \
		> "${path_by_deflosting_restore_target_file}"
	restore_target_file_path=""
	make_restore_target_file_path \
		"${restore_target_file_source_path}"\
		"${restore_target_dir_path}"
	unset -v restore_target_file_source_path
	unset -v restore_target_dir_path
	case "$(echo "${restore_target_file_path}" | rga "${GGIP_EXETEND}$")" in 
		"") ;; 
		*) C_OPTION="-c";; 
	esac
	case "${C_OPTION}" in
	"")	
		exec_merge \
			"${path_by_deflosting_restore_target_file}" \
			"${restore_target_file_path}"
		;;
	-c) 
		cp -avf "${path_by_deflosting_restore_target_file}" "${restore_target_file_path}"
		wait;
		;;
	esac
	rm -rf "${DFBK_RESTORE_DIR_PATH}"
	unset -v restore_target_file_path
	exit 0
}