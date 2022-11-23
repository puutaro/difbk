#!/bin/bash


end_judge_for_clean_buckup(){
	local limit_delete_merge_file_num=3
	case "${registered_merge_file_paths_con}" in 
		"")
			echo "no exist target register_merge_file"
			exit 0
	;;esac

	local row_num_in_register_merge_files_con=$(\
		echo "${registered_merge_file_paths_con}" \
			| wc -l \
			| sed 's/\ //g'\
	)

	if [ ${DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST} -gt ${row_num_in_register_merge_files_con} ];then 
		echo "cant't leave ( save data num: ${row_num_in_register_merge_files_con}"
		exit 0
	fi
	if [ ${row_num_in_register_merge_files_con} -le ${limit_delete_merge_file_num} ];then 
		echo "you can't clean over register day limit : ${limit_delete_merge_file_num})"
		exit 0
	fi

	case "${delete_supper_merge_list_path}" in 
		"") 
			echo "not exist delete_supper_merge_list_path"
			exit 0
	;;esac
	if [ ! -e "${delete_supper_merge_list_path}" ];then 
		echo "not found delete_supper_merge_list_path"
		exit 0
	fi
}