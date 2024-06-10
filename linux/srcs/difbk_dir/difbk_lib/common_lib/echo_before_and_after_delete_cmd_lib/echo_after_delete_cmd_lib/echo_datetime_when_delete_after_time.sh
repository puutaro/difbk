#!/bin/bash


echo_datetime_when_delete_after_time(){
	local minits_depth_paths_con="${1}"
	local DA_OPTION_ENTRY="${2}"
	case "${DA_OPTION_ENTRY}" in
		"") echo ""
			return ;;
	esac
	local sed_da_option_entry="${DA_OPTION_ENTRY//\//\\\/}"
	echo "${minits_depth_paths_con}" \
	| sed -r \
		-e "1i ${sed_da_option_entry}" \
		-e "s/^(${sed_da_option_entry})(.*)$/\1/" \
	| sort \
	| rga "${DA_OPTION_ENTRY}" -A 1 \
	| sed -n '2p'
}
