#!/bin/bash

DIFBK_LABEL_LIB_DIR_PATH="${DIFBK_BK_LIB_DIR_PATH}/label_lib"

. "${DIFBK_LABEL_LIB_DIR_PATH}/end_judge_when_label_options_multiple.sh"
. "${DIFBK_LABEL_LIB_DIR_PATH}/exec_mk_label.sh"
. "${DIFBK_LABEL_LIB_DIR_PATH}/exec_rm_label.sh"
. "${DIFBK_LABEL_LIB_DIR_PATH}/exec_ls_label.sh"

unset -v DIFBK_LABEL_LIB_DIR_PATH


label(){
	end_judge_when_label_options_multiple
	exec_mk_label
	exec_rm_label
	exec_ls_label
}

