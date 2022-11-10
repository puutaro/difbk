#!/bin/bash


read_args_mrg(){
	local STR=""
	while (( $# > 0 ))
	do
	case "${1:-}" in
		"${DIFBK_MRG_CMD_VALIABLE}");;
		-b)
			B_OPTION="${2}"
			shift;;
		"${DIFBK_SCH_CMD_VALIABLE}");;
		"${ALT_ARGS_NAME}")
			MRG_TARGET_DIR_NAME="${2}"
			MRG_BUCKUP_DIR_NAME="${3}"
			shift
			shift
			;;
		"${DEST_ARGS_NAME}")
			DEST_PAR_DIR_NAME="${2}"
			shift
			;;
	esac
	shift
	done <<- END
	$STR
	END
}
