#!/bin/bash


echo_desk_rga_v_cmd_for_diff(){
	local dv_option="${1}"
	local rga_after_num="${2}"
	case "${dv_option}" in 
	",\"\""|"") 
		echo "" 
		return
	;; esac
	echo ${dv_option} \
		| sed \
			-re "s/,(${DESC_PREFIX})\.\*([^,]{1,100})/ | sed '\/\\\[2\\\] \1.*\2\/,+${rga_after_num}d'/g"
}