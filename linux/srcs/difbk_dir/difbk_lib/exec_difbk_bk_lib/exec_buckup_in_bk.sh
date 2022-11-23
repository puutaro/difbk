#!/bin/bash


EXEC_BUCKUP_IN_BK_LIB="${DIFBK_BK_LIB_DIR_PATH}/exec_buckup_in_bk_lib"
. "${EXEC_BUCKUP_IN_BK_LIB}/incremental_copy.sh"
. "${EXEC_BUCKUP_IN_BK_LIB}/make_marge_list_file.sh"
. "${EXEC_BUCKUP_IN_BK_LIB}/place_discription_file.sh"


exec_buckup_in_bk(){
	case "${DRY_BK_OPTION}" in
		"");;
		*) return
	esac
	if [ ! -d ${BUCKUP_MERGE_CONTENSTS_LIST_DIR_PATH} ];then 
		mkdir -p ${BUCKUP_MERGE_CONTENSTS_LIST_DIR_PATH}; 
	fi
	incremental_copy \
		"${LS_CREATE_BUCKUP_MERGE_CONTENTS}"
	wait
	make_marge_list_file \
		"${LS_BUCKUP_MERGE_CONTENTS}"

	place_discription_file \
	"${AFTER_DESC_CONTENTS}"
}