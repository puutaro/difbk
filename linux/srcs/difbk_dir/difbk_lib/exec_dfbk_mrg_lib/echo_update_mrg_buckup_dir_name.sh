#!/bin/bash


echo_update_mrg_buckup_dir_name(){
	local mrg_target_dir_name="${1}"
	local mrg_buckup_dir_name="${2}"
	case "${mrg_buckup_dir_name}" in 
		"-") 
			echo "${OLD_PREFIX}_${mrg_target_dir_name}" 
			;;
		"_") 
			echo ""
			;;
		*)
			echo "${mrg_buckup_dir_name}"
	esac
}