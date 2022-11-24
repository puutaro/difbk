#!/bin/bash


read_args_lrs(){
	local STR=""
	while (( $# > 0 ))
	do
	case ${1:-} in
		-b)
			B_OPTION="${2}"
			shift;;
		-d)
			D_OPTION+="${DESC_PREFIX}.*${2}"
			shift;;
		-da)
			DA_OPTION_ENTRY="${2}"
			shift;;
		-db)
			DB_OPTION_ENTRY="${2}"
			shift;;
		-dv)
			DV_OPTION+=",${DESC_PREFIX}.*${2}"
			shift;;
		-d[a-z])
			dRGA_OPTION+=" ${1} \"${DESC_PREFIX}.*${2}\""		
			shift;;
		-e)
			E_OPTION="${1}"
			;;	
		-*)
			shift;;
	esac
	shift
	done <<- END
	$STR
	END
}
