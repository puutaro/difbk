#!/bin/bash


make_exec_clean_rmdir_path(){
	local exec_clean_dir_path="${1}"
	local exec_clean_rmdir_path="${exec_clean_dir_path}/exec_dir_clean.sh"
	local LANG=C 
	echo "[2/2] empty dir clean "
	while :
	do
		echo -n "#"
		local delete_buckup_blank_dir_list_con_source=$(\
			fd \
				-t d -t empty \
				-IH . "${BUCK_UP_DIR_PATH}" \
		) 
		case "${delete_buckup_blank_dir_list_con_source}" in
			"") break
		;;esac
		local delete_buckup_blank_dir_list_con=$(\
			echo "${delete_buckup_blank_dir_list_con_source}" \
			| sed 's/^'${SED_TARGET_PAR_DIR_PATH}'//' \
			| sort \
			| uniq \
		)
		echo "${delete_buckup_blank_dir_list_con}" \
			| sed -r 's/(.*)/"..\1" \\/' \
			| sed -r '1~8s/(.*)/\& \n rm -rf \1/' \
			| sed \
				-e '$ s/\\$//' \
				-e '1s/\&//' \
			> "${exec_clean_rmdir_path}"
		bash "${exec_clean_rmdir_path}"
		wait
	done
}