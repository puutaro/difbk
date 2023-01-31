#!/bin/bash


EXEC_BK_AND_RBK_HANDLER_LIB_PATH="${DIFBK_BK_LIB_DIR_PATH}/exec_bk_and_rbk_handler_lib"


. "${EXEC_BK_AND_RBK_HANDLER_LIB_PATH}/exec_buckup_in_bk.sh"


unset -v EXEC_BK_AND_RBK_HANDLER_LIB_PATH


exec_bk_and_rbk_handler(){
	local rs_bk_option="${1}"
	local merge_list_file_path="${2}"


	case "${rs_bk_option}" in
	"") 
		exec_buckup_in_bk \
			"${BUCKUP_MERGE_CONTENSTS_LIST_DIR_PATH}" \
			"${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
			"${LS_BUCKUP_MERGE_CONTENTS}" \
			"${AFTER_DESC_CONTENTS}"
		return
		;;
	esac

	local rsbk_mrg_dir_path="$(dirname ${merge_list_file_path})"
	local rsbk_cr_dir_path="$(dirname "${rsbk_mrg_dir_path}")/${BACKUP_CREATE_DIR_NAME}"
	local buckup_dir_prefix="${rsbk_cr_dir_path//${SED_TARGET_PAR_DIR_PATH}/}" 
	unset -v rsbk_mrg_dir_path
	local merge_list_file_path_con=$(\
		zcat "${merge_list_file_path}" \
		| sed -r 's/(.*)\t(\/'${BUCK_UP_DIR_NAME}'\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/'${BACKUP_CREATE_DIR_NAME}')(.*)/\1\t\2\t\3/' \
	)
	local ls_rs_bk_contents=$(\
		echo "${LS_DELETE_BUCKUP_MERGE_CONTENTS}" \
		| sed -r 's/(.*)\t(.*)/\1\t-\t\2/' \
	)
	LS_BUCKUP_MERGE_CONTENTS=$(\
			cat \
				<(\
					echo "${merge_list_file_path_con}"\
				) \
				<(\
					echo "${ls_rs_bk_contents}"\
				) \
			| sort -r \
			| uniq -f2 -d \
			| rga -v "${CHECH_SUM_DIR_INFO}" \
			| sed -r 's/(.*)\t(.*)\t(.*)/\1\t\2\3/'\
	)
	copy_and_unzip \
		"${TARGET_PAR_DIR_PATH}"
}