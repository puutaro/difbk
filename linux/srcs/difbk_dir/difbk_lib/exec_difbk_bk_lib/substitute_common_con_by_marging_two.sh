#!/bin/bash


substitute_common_con_by_marging_two(){
	local ls_buckup_merge_contents="${1}"
	local diff_ls_contents="${2}"
	case "${diff_ls_contents}" in 
		"")	echo "${ls_buckup_merge_contents}"
			return
	;; esac
	local target_list_mark="TLTLTLTLTLTLTLTTLTLTL"
	cat \
		<(\
			echo "${diff_ls_contents}" \
				| sed -r "s/^([0-9d]{1,20})\t/\1\t${target_list_mark}\t/"\
		) \
		<(\
			echo "${ls_buckup_merge_contents}" \
				| sed -r "s/^([0-9d]{1,20})\t(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})(.*)/\1\t\2\t\3/" \
		) \
	| sort -k 3 \
	| uniq -u -f 2 \
	| rga -v "[0-9d]{1,20}\t${target_list_mark}\t" \
	| sed -r "s/^([0-9d]{1,20})\t(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})\t(.*)/\1\t\2\3/"
}