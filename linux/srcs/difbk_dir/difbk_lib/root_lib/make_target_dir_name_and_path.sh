#!/bin/bash


make_target_dir_name_and_path(){
	local b_option="${1}"
	case "${b_option:-}" in 
		"")
			TARGET_DIR_PATH=$(pwd)
			TARGET_DIR_NAME="$(basename "${TARGET_DIR_PATH}")"
			return
	;; esac
	case "$(basename "${b_option}" | rga "${OLD_PREFIX}")"  in 
		"") 
			echo "buckup old dir must be specfied:  ${B_OPTION}"
			exit 0;;
	esac
	local absolute_path=$(realpath "${B_OPTION}")
	[ ! -e "${absolute_path}" ] \
		&& echo "no exist buckup dir path: ${absolute_path}" \
		&& exit 0 \
		|| e=$?
	if [ ! -e "$(echo "${absolute_path}" | rga "${OLD_PREFIX}_")" ] \
		|| [ ! -e "${absolute_path}" ];then 
			return
	fi
	TARGET_DIR_NAME=$(\
		basename "${absolute_path}" \
			| sed "s/${OLD_PREFIX}_//"\
	)
	TARGET_DIR_PATH="$(dirname "${absolute_path}")/${TARGET_DIR_NAME}"
}


realpath() {
	local input_path="${1}"
	case "${input_path}" in 
		/*) 
			echo "${input_path}"
			return
	;; esac
	printf '%s' "$PWD"
}
