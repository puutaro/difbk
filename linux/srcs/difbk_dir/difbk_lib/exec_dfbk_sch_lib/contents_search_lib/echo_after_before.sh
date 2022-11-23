#!/bin/bash


echo_after_before(){
	local check_str="${1}"
	local after_before=""
	case "${check_str}" in 
		"") echo "-A ${third_para_suffix} -B ${third_para_suffix}"
			return
			;;
	esac
 	echo ""
}