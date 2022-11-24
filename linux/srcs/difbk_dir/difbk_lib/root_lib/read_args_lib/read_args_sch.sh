#!/bin/bash


read_args_sch(){
	local STR=""
	while (( $# > 0 ))
	do
	case "${1:-}" in
		"${DIFBK_SCH_CMD_VALIABLE}");;
		-b)
			B_OPTION="${2}"
			shift;;
		-c|-c[0-9]*)
			C_OPTION+="${1}";;
		-d)
			D_OPTION+="${DESC_PREFIX}.*${2}"
			shift
			;;
		-da)
			DA_OPTION_ENTRY="${2}"
			shift;;
		-db)
			DB_OPTION_ENTRY="${2}"
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
			GENERAL_OPTION+=",${1} '${2}'"
			shift;;
		-v)
			V_OPTION+=",${1} \"${2}\""
			shift;;
		-o)
			O_OPTION+=",${1} '${2}'"
			shift;;
		-j)
			J_OPTION="${1} ${2}"
			shift;;
		-*)
			GENERAL_OPTION+=",${1} '${2}'"
			shift;;
		*)
			DIFBK_SEARCH_WORD+=",\"${1}\""
	esac
	shift
	done <<- END
	$STR
	END
}
