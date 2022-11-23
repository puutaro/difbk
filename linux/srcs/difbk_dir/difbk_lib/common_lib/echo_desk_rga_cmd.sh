#!/bin/bash


echo_desk_rga_cmd(){
	local rga_after_num="${1}"
	case "${D_OPTION}" in 
	",\"\"") 
		echo ""
		return
		;;
	"")
		;;
	*)
		echo ${D_OPTION} \
			| sed \
				-re "s/(${DESC_PREFIX})/\" | rga -A ${rga_after_num} ${dRGA_OPTION} \"\1/g" \
				-e 's/^"//' \
				-e 's/$/"/' 
		return

	esac
	case "${dRGA_OPTION}" in
		"")
			echo ""
			return
		;;
	esac
	echo " | rga -A ${1:-} ${dRGA_OPTION}"
}
