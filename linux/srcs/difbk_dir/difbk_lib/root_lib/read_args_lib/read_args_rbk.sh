#!/bin/bash


read_args_rbk(){
	local STR=""
	while (( $# > 0 ))
	do
	case "${1}" in
		-*)
			echo "no option" ;;
		*)	
			j_option_check "${1}"
			J_OPTION="${1:-} "
			;;
	esac
	shift
	done <<- END
	$STR
	END
}


j_option_check(){
	local j_option_entory="${1}"
	case "${j_option_entory}" in "${DIFBK_RBK_CMD_VALIABLE}") return;; esac
	expr "${j_option_entory}" : "[0-9]*$" >&/dev/null
	local err_status=$?
	case "${err_status}" in "1") echo "j option must be 0 over number"; exit 0 ;;esac
	case "${j_option_entory}" in "0") echo "j option must be 0 over number"; exit 0 ;;esac
}