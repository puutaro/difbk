#!/bin/bash


echo_mkdir_shell_con(){
	local get_dir_name_shell_path="${DFBK_SETTING_DIR_PATH}/get_dir_name.sh"
	local mkdir_shell_con_source=$(\
		echo "${COPY_CONTENTS}" \
			| rga "${CHECH_SUM_DIR_INFO}" \
			| cut -f2 \
			| sed \
				-e "s/^/mkdir -p \"/" \
				-e "s/$/\" \&/"\
	)
	case "${FULL_OPTION:-}" in 
		"");;
		*) 
			echo "${mkdir_shell_con_source}"
			return
	;; esac
	echo "${COPY_CONTENTS}" \
		| rga -v "${CHECH_SUM_DIR_INFO}" \
		| cut -f2 \
		| sed \
			-e "s/^/dirname \"/" \
			-e "s/$/\" \&/" \
		> "${get_dir_name_shell_path}"
	local dir_name_con=$(\
		bash "${get_dir_name_shell_path}" \
		| sort \
		| uniq\
	)
	cat \
		<(\
			echo "${dir_name_con}" \
			| sed \
				-e '/^$/d' \
				-e "s/^/mkdir -p \"/" \
				-e "s/$/\" \&/"\
		) \
		<(\
			echo  "${mkdir_shell_con_source}"\
		) \
	| sed '/^$/d' \
	| sort \
	| uniq
}