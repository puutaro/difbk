#!/bin/bash


echo_update_mrg_target_dir_name(){
	local mrg_target_dir_name="${1}"
	case "${mrg_target_dir_name}" in 
		"-") 
			echo "${TARGET_DIR_NAME}"
			;; 
		"_") 
			echo "" 
			;;
		*) 
			echo "${mrg_target_dir_name}" 
			;;
	esac
}