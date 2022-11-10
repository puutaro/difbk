#!/bin/bash

READ_ARGS_LIB_PATH="${DIFBK_ROOT_LIB_PATH}/read_args_lib"

. "${READ_ARGS_LIB_PATH}/read_args_bk.sh"
. "${READ_ARGS_LIB_PATH}/read_args_rs.sh"
. "${READ_ARGS_LIB_PATH}/read_args_lrs.sh"
. "${READ_ARGS_LIB_PATH}/read_args_sch.sh"
. "${READ_ARGS_LIB_PATH}/read_args_diff.sh"
. "${READ_ARGS_LIB_PATH}/read_args_clean.sh"
. "${READ_ARGS_LIB_PATH}/read_args_mrg.sh"


difbk_sub_cmd="${DIFBK_SUB_CMD}"
read_args(){
	local count_for_normal_arg=0
	case "${difbk_sub_cmd}" in
		"${DIFBK_BK_CMD_VALIABLE}")
			D_OPTION=""
			LN_OPTION=""
			DN_OPTION=""
			FULL_OPTION=""
			LSLABEL_CON=""
			MKLABEL_CON=""
			RMLABEL_CON=""
			read_args_bk "$@"
		;;
		"${DIFBK_RS_CMD_VALIABLE}")
			B_OPTION=""
			C_OPTION=""
			DIFBK_ARGUMENT_LIST=""
			read_args_rs "$@"
			;;
		"${DIFBK_LRS_CMD_VALIABLE}")
			B_OPTION=""
			D_OPTION=""
			DV_OPTION=""
			dRGA_OPTION=""
			E_OPTION=""
			DIFBK_ARGUMENT=""
			read_args_lrs "$@"
			;;
		"${DIFBK_SCH_CMD_VALIABLE}")
			B_OPTION=""
			D_OPTION=""
			DV_OPTION=""
			dRGA_OPTION=""
			E_OPTION=""
			DIFBK_ARGUMENT=""
			read_args_sch "$@"
			;;
		"${DIFBK_DIFF_CMD_VALIABLE}")
			B_OPTION=""
			D_OPTION=""
			DV_OPTION=""
			dRGA_OPTION=""
			E_OPTION=""
			DIFBK_ARGUMENT=""
			read_args_diff "$@"
			;;
		"${DIFBK_CLEAN_CMD_VALIABLE}")
			LAST_LEFT_ORDER_FOR_MERGE_LIST=""
			read_args_clean "$@"
			;;
		"${DIFBK_MRG_CMD_VALIABLE}")
			B_OPTION=""
			ALT_OPTION_LIST=""
			DEST_PAR_DIR_NAME=""
			read_args_mrg "$@"
			;;
	esac
}
