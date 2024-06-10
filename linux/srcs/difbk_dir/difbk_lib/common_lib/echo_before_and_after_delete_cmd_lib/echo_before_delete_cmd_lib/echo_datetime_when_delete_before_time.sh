#!/bin/bash


echo_datetime_when_delete_before_time(){
	local minits_depth_paths_con="${1}"
	local DB_OPTION_ENTRY="${2}"
	case "${DB_OPTION_ENTRY}" in
		"") echo ""
			return ;;
	esac
	local sed_da_option_entry="${DB_OPTION_ENTRY//\//\\\/}"
	echo "${minits_depth_paths_con}" \
	| sed -r \
		-e "1i ${sed_da_option_entry}" \
		-e "s/^(${sed_da_option_entry})(.*)$/\1/" \
	| sort -r \
	| rga "${DB_OPTION_ENTRY}" -A 1 \
	| sed -n '2p'
}
