#!/bin/bash


substitute_common_con_by_marging_two(){
	case "${LS_DELETE_BUCKUP_MERGE_CONTENTS}" in 
		"")	echo "${LS_BUCKUP_MERGE_CONTENTS}"
			return
	;; esac
	local target_list_mark="TLTLTLTLTLTLTLTTLTLTL"
	cat \
		<(\
			echo "${LS_DELETE_BUCKUP_MERGE_CONTENTS}" \
				| sed -r "s/^([0-9d]{1,20})\t/\1\t${target_list_mark}\t/"\
		) \
		<(\
			echo "${LS_BUCKUP_MERGE_CONTENTS}" \
				| sed -r "s/^([0-9d]{1,20})\t(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})(.*)/\1\t\2\t\3/" \
		) \
	| sort -k 3 \
	| uniq -u -f 2 \
	| rga -v "[0-9d]{1,20}\t${target_list_mark}\t" \
	| sed -r "s/^([0-9d]{1,20})\t(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})\t(.*)/\1\t\2\3/"
}