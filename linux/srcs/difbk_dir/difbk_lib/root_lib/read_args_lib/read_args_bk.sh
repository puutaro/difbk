#!/bin/bash


read_args_bk(){
	local STR=""
	while (( $# > 0 ))
	do
	case "${1}" in
		-b)
			echo "bk option is invalid in bk"
			exit 0
			;;
		-d)
			D_OPTION="${1}, ${2}"
			shift;;
		-dn)
			DN_OPTION="${1}"
			;;
		-ln)
			LN_OPTION="${1}" 
			;;
		"${FULL_OPTION_NAME}")
			FULL_OPTION="${FULL_OPTION_NAME}" ;;
		"${LSLABEL_ARGS}") 
			LSLABEL_CON="${1}"
			;;
		"${MKLABEL_ARGS}") 
			MKLABEL_CON="${2}"
			;;
		"${RMLABEL_ARGS}") 
			RMLABEL_CON="${2}"
			;;
		-*)
			shift;;
		${DIFBK_BK_CMD_VALIABLE})
			;;
		*)	
			BK_DESK_CONTENTS+="${1:-} "
			;;
	esac
	shift
	done <<- END
	$STR
	END
}
