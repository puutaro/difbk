#!/bin/bash


read_args_diff(){
	local STR=""
	while (( $# > 0 ))
	do
	case "${1:-}" in
		"${DIFBK_SCH_CMD_VALIABLE}");;
		-b)
			B_OPTION="${2}"
			shift;;
		-d)
			D_OPTION+="${DESC_PREFIX}.*${2}"
			shift
			;;
		-da)
			DA_OPTION+="${DESC_PREFIX}.*${2}"
			shift;;
		-db)
			DB_OPTION+="${DESC_PREFIX}.*${2}"
			shift;;
		-dv)
			DV_OPTION+=",${DESC_PREFIX}.*${2}"
			shift;;
		-do)
			shift;;
		-d[a-z])
			dRGA_OPTION+=" ${1} \"${DESC_PREFIX}.*${2}\""
			shift;;
		-A|-B)
			shift;;
		-e)
			E_OPTION="${1}"
			;;
		-*)
			GENERAL_OPTION+=",${1} '${2}'"
			shift;;
		"${DIFBK_DIFF_CMD_VALIABLE}")
			;;
		*)
			DIFBK_ARGUMENT+=",\"${1}\""
	esac
	shift
	done <<- END
	$STR
	END
}
