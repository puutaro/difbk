#!/bin/bash



echo_before_merge_list_path_for_diff(){
	local second_para="${1}"
	local second_para_janre="${2}"
	case "${J_OPTION}" in
		"") ;;
		*)
			return
	;; esac
	case "${second_para_janre}" in
		"${JANRE_MERGE_LIST_NUM}") ;;
		${JANRE_MERGE_LIST_PATH}) 
			echo "${second_para}" \
				| sed 's/\.\./'${SED_TARGET_PAR_DIR_PATH}'/'
			return ;;
		*)
			return
			;;
	esac
	local merge_list_depth=6
	case "${E_OPTION}" in 
		"");;
		*)
			fd . "${BUCK_UP_DIR_PATH}" -d "${merge_list_depth}" \
			| rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" \
			| sort -r \
			| sed -n ''${second_para}'p'
			return
			;;
	esac
	fd . "${BUCK_UP_DIR_PATH}" -d "${merge_list_depth}" \
		| rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" \
		| sort -r \
		| sed -r "s/^(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})/\2\t\1/" \
		| uniq -f 1  \
		| sed \
			-r "s/^(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})\t(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})/\2\1/" \
		| sed -n ''${second_para}'p'
}