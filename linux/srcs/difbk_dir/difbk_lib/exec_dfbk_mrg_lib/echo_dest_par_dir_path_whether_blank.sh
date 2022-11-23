#!/bin/bash


echo_dest_par_dir_path_whether_blank(){
	local dest_par_dir_name="${1}"
	case "${dest_par_dir_name}" in 
		"") echo "${SED_TARGET_PAR_DIR_PATH}"
			;;
		*) 
			echo "${dest_par_dir_name}" \
				| sed -r 's/([^a-zA-Z_-])/\\\1/g'\
			;; 
	esac
}