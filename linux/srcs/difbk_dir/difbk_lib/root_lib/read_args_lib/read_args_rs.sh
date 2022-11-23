#!/bin/bash


read_args_rs(){
	local STR=""
	count_for_normal_arg=0
	while (( $# > 0 ))
	do
	case "${1}" in
		-b)
			B_OPTION="${2}"
			shift;;
		-c)
			C_OPTION="${1}"
			;;
		-*)
			shift;;
		*)	
			judge_sub_cmd_or_args "${1}"
			;;
	esac
	shift
	done <<- END
	$STR
	END
}


judge_sub_cmd_or_args(){
	case "${SHIFT_SEED}" in 
		"0") 
			SHIFT_SEED=$((${SHIFT_SEED} + 1))
			;;
		*) 
			DIFBK_ARGUMENT_LIST[${count_for_normal_arg}]="${1:-}"
			count_for_normal_arg=$(( ${count_for_normal_arg} + 1 ))
			;;
	esac
}