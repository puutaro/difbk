#!/bin/bash


echo_desk_rga_v_cmd(){
	local rga_after_num="${1}"
	case "${DV_OPTION:-}" in 
	",\"\""|"") 
		echo ""
		return
		;;
	esac
	echo ${DV_OPTION:-} \
		| sed -re "s/,(${DESC_PREFIX})\.\*([^,]{1,100})/ | sed '\/\1.*\2\/,+${rga_after_num}d'/g"
}