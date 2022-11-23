#!/bin/bash


end_judge_when_no_exist_mrg_target_dir_name(){
	local mrg_target_dir_name=${1}
	case "${mrg_target_dir_name}" in 
		"") 
			echo "when mrg_target_dir_name is blank, marg_buckup_dir_name cannnot be used hyphen"
			exit 0
	;; esac
	case "$(echo "${mrg_target_dir_name}" | rga "/")" in 
		"");;
		*) 
			echo "must be specified buckup dir path"
			exit 0
	;; esac		
}
