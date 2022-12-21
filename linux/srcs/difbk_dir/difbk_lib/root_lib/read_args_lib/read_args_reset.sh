#!/bin/bash


read_args_reset(){
	local STR=""
	while (( $# > 0 ))
	do
	case "${1:-}" in
		-s)
			S_OPTION="${1:-}"
			echo aa
			;;
	esac
	shift
	done <<- END
	$STR
	END
}