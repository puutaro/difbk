#!/bin/bash

READ_ARGS_LIB_PATH="${DIFBK_ROOT_LIB_PATH}/read_args_lib"

. "${READ_ARGS_LIB_PATH}/read_args_bk.sh"
. "${READ_ARGS_LIB_PATH}/read_args_rs.sh"
. "${READ_ARGS_LIB_PATH}/read_args_lrs.sh"
. "${READ_ARGS_LIB_PATH}/read_args_sch.sh"
. "${READ_ARGS_LIB_PATH}/read_args_diff.sh"
. "${READ_ARGS_LIB_PATH}/read_args_clean.sh"
. "${READ_ARGS_LIB_PATH}/read_args_mrg.sh"
. "${READ_ARGS_LIB_PATH}/read_args_reset.sh"
. "${READ_ARGS_LIB_PATH}/read_args_rbk.sh"
. "${READ_ARGS_LIB_PATH}/read_args_st.sh"
. "${READ_ARGS_LIB_PATH}/read_args_sd.sh"


difbk_sub_cmd="${DIFBK_SUB_CMD}"
read_args(){
	local count_for_normal_arg=0
	case "${difbk_sub_cmd}" in
		"${DIFBK_BK_CMD_VALIABLE}")
			D_OPTION=""
			J_OPTION=""
			LN_OPTION=""
			DN_OPTION=""
			FULL_OPTION=""
			LSLABEL_CON=""
			MKLABEL_CON=""
			RMLABEL_CON=""
			DRY_BK_OPTION=""
			RS_BK_OPTION=""
			read_args_bk "$@"
		;;
		"${DIFBK_RBK_CMD_VALIABLE}")
			J_OPTION=""
			read_args_rbk "$@"
		;;
		"${DIFBK_ST_CMD_VALIABLE}")
			J_OPTION=""
			read_args_st "$@"
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
			DA_OPTION_ENTRY=""
			DB_OPTION_ENTRY=""
			FULL_OPTION=""
			read_args_lrs "$@"
			;;
		"${DIFBK_SCH_CMD_VALIABLE}")
			B_OPTION=""
			D_OPTION=""
			DV_OPTION=""
			dRGA_OPTION=""
			E_OPTION=""
			DIFBK_ARGUMENT=""
			DA_OPTION_ENTRY=""
			DB_OPTION_ENTRY=""
			read_args_sch "$@"
			;;
		"${DIFBK_DIFF_CMD_VALIABLE}")
			B_OPTION=""
			D_OPTION=""
			DV_OPTION=""
			dRGA_OPTION=""
			E_OPTION=""
			DIFBK_ARGUMENT=""
			DA_OPTION_ENTRY=""
			DB_OPTION_ENTRY=""
			read_args_diff "$@"
			;;
		"${DIFBK_SDIFF_CMD_VALIABLE}")
			RJ_OPTION=""
			read_args_sd "$@"
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
		"${DIFBK_RESET_CMD_VALIABLE}")
			S_OPTION=""
			read_args_reset "$@"
			;;
	esac
}
