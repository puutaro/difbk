#!/bin/bash


display_bk_result(){
	local ls_create_buckup_merge_contents="${1}"
	local ls_delete_buckup_merge_contents="${2}"
	echo "${SEPARATE_BAR}"
	case "${ls_delete_buckup_merge_contents}" in 
		"") delete_item_total=0 ;; 
		*) delete_item_total=$(\
				echo "${ls_delete_buckup_merge_contents}" \
				| wc -l\
			)
			;;
	esac
	echo "delete_items total: ${delete_item_total}"
	echo "$(\
			echo "${ls_delete_buckup_merge_contents}" \
				| cut -f2 \
				| head -n ${DISPLAY_NUM_LIST}\
	)"
	case "${ls_create_buckup_merge_contents}" in 
		"") create_item_total=0 ;; 
		*) create_item_total=$(\
				echo "${ls_create_buckup_merge_contents}" \
				| wc -l\
			)
			;;
	esac
	echo "create_items total: ${create_item_total}"
	echo "$(\
		echo "${ls_create_buckup_merge_contents}" \
		| cut -f2 \
		| head -n "${DISPLAY_NUM_LIST}"\
	)"
}