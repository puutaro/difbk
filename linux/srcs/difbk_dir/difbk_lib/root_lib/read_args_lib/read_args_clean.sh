#!/bin/bash


read_args_clean(){
	local STR=""
	while (( $# > 0 ))
	do
	case "${1:-}" in
		-b)
			echo "bk option is invalid in bk"
			exit 0
			;;
		"${DIFBK_SCH_CMD_VALIABLE}");;
		"${BUCKUP_CLEAN_ARGS_NAME}")
			DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST="${2:-}"
			shift
			;;
		"${LATEST_MERGE_LIST_VALIDATE_ARGS_NAME}")
			LATEST_MERGE_LIST_VALIDATE_ARGS_OPTION="${1}"
			;;
	esac
	shift
	done <<- END
	$STR
	END
}
