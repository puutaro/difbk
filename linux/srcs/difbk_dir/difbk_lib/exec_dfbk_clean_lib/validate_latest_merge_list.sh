#!/bin/bash


validate_recent_merge_list_lib_path="${EXEC_DFBK_CLEAN_LIB_PATH}/validate_latest_merge_list_lib"
. "${validate_recent_merge_list_lib_path}/echo_latest_merge_file_list_path.sh"
. "${validate_recent_merge_list_lib_path}/echo_delete_list_in_validate_latest_mrg_ls.sh"
. "${validate_recent_merge_list_lib_path}/write_out_modify_merge_list.sh"


unset -v validate_recent_merge_list_lib_path


validate_latest_merge_list(){
	local recent_merge_list_validate_args_option="${1}"
	case "${recent_merge_list_validate_args_option}" in
		"") 
			return 
		;;
	esac
	local latest_merge_file_list_path=$(\
		echo_latest_merge_file_list_path \
	)

	if [ -z "${latest_merge_file_list_path}" ];then echo "no exist target register_merge_file"; exit 0; fi

	if [ ! -e "${latest_merge_file_list_path}" ];then 
		echo "no list_file"; 
		exit 0;
	fi
	local base_list_contents_source=$(zcat ${latest_merge_file_list_path})
	local base_list_contents=$(\
		echo "${base_list_contents_source}" \
		| cut -f2\
	)
	local day_depth_path_list=$(\
		fd \
			-t d --max-depth 3 \
			. ${BUCK_UP_DIR_PATH} \
		| rga "${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}" \
		| sort\
	)

	local IFS=$'\n'
	local day_depth_path_list_l=($(echo "${day_depth_path_list}"))
	local IFS=$' \n'
	local delete_list=$(\
		echo_delete_list_in_validate_latest_mrg_ls \
			"${day_depth_path_list_l[@]}" \
			"${base_list_contents}" \
	)
	if [ -z "${delete_list}" ];then 
		echo "it's correct (${latest_merge_file_list_path}"
		exit 0
	fi
	local modify_merge_list=$(\
		write_out_modify_merge_list \
			"${latest_merge_file_list_path}" \
			"${delete_list}" \
			"${base_list_contents_source}" \
	)
	if [ -n "${delete_list}" ];then 
		echo "modify (it's incorrect (${latest_merge_file_list_path}"; 
		echo "delete_path_list"
		echo "${delete_list}" | cut -f2 | head -n ${DISPLAY_NUM_LIST}
		echo "total_delete: $(echo "${delete_list}" | wc -l | sed 's/\ //g')"
	fi
	exit 0
}