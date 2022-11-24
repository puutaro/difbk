#!/bin/bash

MAKE_DIFF_FILE_PAIR_AND_LABEL_AND_TARGET_MERGE_LIST_LIB_PATH="${EXEC_DIFBK_DIFF_LIB_PATH}/make_diff_file_pair_and_label_and_target_merge_list_lib"
. "${MAKE_DIFF_FILE_PAIR_AND_LABEL_AND_TARGET_MERGE_LIST_LIB_PATH}/echo_diff_file_pair_con.sh"
. "${MAKE_DIFF_FILE_PAIR_AND_LABEL_AND_TARGET_MERGE_LIST_LIB_PATH}/echo_diff_file_pair_con_for_cur_dir_order.sh"

unset -v MAKE_DIFF_FILE_PAIR_AND_LABEL_AND_TARGET_MERGE_LIST_LIB_PATH


make_diff_file_pair_and_label_and_target_merge_list(){
	local second_para="${1}"
	local recent_merge_list_path="${2}"
	local before_merge_list_path="${3}"
	echo "make_diff_file_pair_and_label_and_target_merge_list:second_para ${second_para}"
	case "${second_para}" in
		"${CURRENT_TARGET_DIR_ORDER}")
			;;
		*)
			sed_before_diff_label=""
			diff_file_pair_con=""
			echo_diff_file_pair_con \
				"${recent_merge_list_path}" \
				"${before_merge_list_path}"

			TARGET_MERGE_LIST="$(\
				echo "${diff_file_pair_con}" \
				| sed -r 's/"(.*)"/\1/' \
				| sed 's/\.\./'${SED_TARGET_PAR_DIR_PATH}'/'\
			)"
			return
			;;
	esac

	TARGET_MERGE_LIST=$(\
		zcat "${recent_merge_list_path}" \
		| cut -f2\
		| sed 's/^/../'
	)
	sed_before_diff_label="-"
	diff_file_pair_con=$(\
		echo_diff_file_pair_con_for_cur_dir_order \
			"${DFBK_CREATE_CON_PATH}" \
			"${TARGET_MERGE_LIST}" \
	)
}