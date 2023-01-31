#!/bin/bash


display_bk_result(){
	local merge_list_file_path="${1}"
	case "${CUR_DIFF_OPTION}" in
		"");;
		*) return
	;;esac
	echo "${SEPARATE_BAR}"
	case "${LS_DELETE_BUCKUP_MERGE_CONTENTS}" in 
		"") delete_item_total=0 ;; 
		*) delete_item_total=$(\
				echo "${LS_DELETE_BUCKUP_MERGE_CONTENTS}" \
				| wc -l\
			)
			;;
	esac


	if [  -n "${RS_BK_OPTION}" ] \
		&& [ -n "${LS_DELETE_BUCKUP_MERGE_CONTENTS}" ]; then
			echo_ls_delete_buckup_merge_contents \
				"\x1b[38;5;2m"
			echo "restore_buckup_items total: ${delete_item_total}"
			local desk_file_path="${merge_list_file_path//${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${SED_DFBK_GGIP_EXETEND}/}${BUCKUP_DESC_FILE_NAME}" 
			cat "${desk_file_path}" | sed -r "s/(.*)/\x1b[38;5;20m\1\x1b[0m/"
			echo "${merge_list_file_path}" 
			return
	fi
	case "${RS_BK_OPTION}" in
		"") ;;
		*) return ;;
	esac

	echo_ls_delete_buckup_merge_contents \
		"\x1b[38;5;130m"
	case "${LS_CREATE_BUCKUP_MERGE_CONTENTS}" in 
		"") create_item_total=0 ;; 
		*) create_item_total=$(\
				echo "${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
				| wc -l\
			)
			;;
	esac
	echo "$(\
		echo "${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
		| cut -f2 \
		| head -n "${DISPLAY_NUM_LIST}"\
		| sed -r 's/(.*)/\x1b[38;5;2m\1\x1b[0m/' \
	)"

	echo "delete_items total: ${delete_item_total}"
	echo "create_items total: ${create_item_total}"
}



echo_ls_delete_buckup_merge_contents(){
	local delete_color="${1}"
	echo "$(\
		echo "${LS_DELETE_BUCKUP_MERGE_CONTENTS}" \
			| cut -f2 \
			| head -n ${DISPLAY_NUM_LIST}\
			| sed -r "s/(.*)/${delete_color}\1\x1b[0m/" \
	)"
}
