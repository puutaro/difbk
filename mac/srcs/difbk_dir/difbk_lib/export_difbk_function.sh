#!/bin/bash

lecho(){
	case ${BUCKUP_DEBUG} in 
		1) echo "${1}";;
	esac
}


make_merge_list_entry(){
	local source_line=$(echo "${1}")
	local source_path=$(echo "${source_line}" | cut -f2)
	if [ ! -d "${source_path}" ];then
		local cksum=$(sum "${source_path}" | awk '{print $1}')
	else 
		local cksum="${CHECH_SUM_DIR_INFO}"
	fi
	if [ -n "${cksum}" ];then echo -e "${cksum}\t${source_path}" ;fi #"${source_line/$'\t'/$'\t'${cksum}$'\t'}"
}

exec_delete_gzip(){
	local delete_entry_path="${1}"
	if [ -n "$(file "${delete_entry_path}" | grep -E ":\s${COMPARE_DIR_WORD}$")" ];then
		if [ -e "${delete_entry_path}" ];then 
			if [ -z "$(ls -A "${delete_entry_path}")" ];then rm -rf "${delete_entry_path}" ;fi
		fi
	else
		get_gz_path=$(echo "${delete_entry_path}" | grep -E "\.gz$")
		if [ -n "${get_gz_path}" ];then
			target_delete_path="${delete_entry_path}"
		else 
			target_delete_path="${delete_entry_path}${DFBK_GGIP_EXETEND}"
		fi
		if [ -e "${target_delete_path}" ];then rm "${target_delete_path}"; fi
	fi
}

exec_find(){
	local find_entry_path="${1}"
	if [ -e "${find_entry_path}" ];then find "${find_entry_path}" -type d -empty;fi
}

du_dir_check_exist_path(){
	if [ -e "${1}" ];then
		check_result="$(file "${1}" | grep -E ":\s${COMPARE_DIR_WORD}$")"
		target_path=$(echo "${1}" | sed 's/\*$//')
		if [ -n "${check_result}" ];then du -s "${target_path}/"* ;fi
	fi
}

du_file_check_exist_path(){
	if [ -e "${1}" ];then
		check_result="$(file "${1}" | grep -E ":\s${COMPARE_DIR_WORD}$")"
		target_path=$(echo "${1}" | sed 's/\*$//')
		if [ "${check_result}" != "${COMPARE_DIR_WORD}" ];then du -h "${1}" ;fi
	fi
}

zip_cat_check_dir_path(){
	if [ -e "${1}" ] && [ ! -d "${1}" ];then gzcat "${1}"; fi
}

zip_cat_wc_check_dir_path(){
	if [ -e "${1}" ] && [ ! -d "${1}" ];then gzcat "${1}"  | wc -l | sed 's/\ //g';
	else echo 0 ; fi
}

zip_grep_file_path(){
	if [ -e "${2}" ] && [ ! -d "${2}" ];then zgrep -iE "${1}" -l "${2}"; fi
}

echo_file_path(){
	if [ -e "${1}" ] && [ ! -d "${1}" ];then echo "${1}"; fi
}

zip_wc_check_path(){
	if [ -e "${1}" ] && [ ! -d "${1}" ];then 
		num=$(gzcat "${1}"  | wc -l | sed 's/\ //g')
		if [  -z "${num}" ];then :;
		elif [  ${num} -eq 402 ];then echo "####  ${1}"; fi
	fi
}

gls_date_sort(){
	if [ "${1}" != '{}' ] || [ -z "${1}" ];then
		gls --full-time "${1}" | sed 's/\-/\//g' |  awk '{print $6"/"$7"\t"$9}'
	fi
}

