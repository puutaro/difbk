#!/bin/bash

exit_judge_to_alt_option_con_zero(){
	local alt_option_con_zero=${1}
	case "${alt_option_con_zero}" in "-") exit 0;; esac
	case "$(echo "${alt_option_con_zero}" | rga "/")" in "");;
		*) echo "must be specified buckup dir path"; exit 0;; esac		
}
