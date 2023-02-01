#!/bin/bash


read_args_rbk(){
	local STR=""
	while (( $# > 0 ))
	do
	case "${1}" in
		-*)
			echo "no option" ;;
		*)	
			J_OPTION="${1:-}"
			;;
	esac
	shift
	done <<- END
	$STR
	END
}
