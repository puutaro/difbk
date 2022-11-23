#!/bin/bash


end_when_j_option_arg_blank(){
	local j_option="${1}"
	local j_option_arg="${2}"
	case "${j_option}" in 
		"") return
	;; esac
	case "${j_option_arg}" in 
		"") 
			echo "no exist j_option_arg";
			exit 0
		;;
	esac
	
}