#!/bin/bash


read_args_st(){
	local STR=""
	while (( $# > 0 ))
	do
	case "${1}" in
		-b)
			echo "b option is invalid in st"
			exit 0
			;;
		-*)
			shift;;
		${DIFBK_ST_CMD_VALIABLE})
			;;
		*)	
			J_OPTION="${1:-}"
			;;
	esac
	shift
	done <<- END
	$STR
	END
}
