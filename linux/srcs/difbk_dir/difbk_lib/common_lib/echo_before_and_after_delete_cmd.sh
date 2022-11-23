#!/bin/bash


echo_before_and_after_delete_cmd(){
	local rga_after_num="${1}"
	local differ_option="${2:-}"
	case "${differ_option:-}" in 
		"");; 
		*) diff_prefix='\[2\] '
	;; esac
	case "${rga_after_num:-}" in 
		"") ;; 
		*) local diff_delete_sed=" | sed '1,${rga_after_num}d'"
	;;esac
	case "${DB_OPTION:-}" in 
		"");; 
		*) 
			local sed_db_option=$(echo ${DB_OPTION:-} | sed  's/\//\\\//g')
			local before_delete_cmd=" | sed -n '/${diff_prefix:-}${sed_db_option}/,\$!p'"
	;;esac
	case "${DA_OPTION:-}" in 
		"");; 
		*) 
		local sed_da_option=$(\
			echo ${DA_OPTION-} \
				| sed  's/\//\\\//g'\
		)
		local after_delete_cmd=" | sed -n '1,/${diff_prefix:-}${sed_da_option:-}/!p' ${diff_delete_sed:-}"
	;;esac
	echo "${before_delete_cmd:-} ${after_delete_cmd:-}"
}