#!/bin/bash


echo_check_str(){
	local third_para_suffix="${1}"
	case "${third_para_suffix}" in 
	    "") 
			echo "nasi"
			;;
	    *) 
			echo "$(echo "${third_para_suffix//[0-9]/}")"
			;;
	esac 
}