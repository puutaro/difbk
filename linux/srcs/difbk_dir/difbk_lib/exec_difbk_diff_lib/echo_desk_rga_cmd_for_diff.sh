#!/bin/bash


echo_desk_rga_cmd_for_diff(){
	local d_option="${1}"
	local drga_option="${2}"
	local rga_after_num="${3}"
	case "${d_option}" in 
	",\"\"") 
		echo ""
		return
		;;
	"") ;;
	*)
		echo ${d_option} \
			| sed \
				-re "s/(${DESC_PREFIX})/\" | rga -A ${rga_after_num} ${drga_option} \"\\\[2\\\] \1/g" \
				-e 's/^"//' \
				-e 's/$/"/' 
		return
		;;
	esac
	case "${drga_option}" in
		"")
			echo ""
			return
			;;
	esac
	echo " | rga -A ${1:-} ${drga_option}"
}