#!/bin/bash


exec_dfbk_lrs_lib_path="${DIFBK_LIB_DIR_PATH}/exec_dfbk_lrs_lib"
. "${exec_dfbk_lrs_lib_path}/display_merge_list_by_daily.sh"
. "${exec_dfbk_lrs_lib_path}/display_merge_list_by_every.sh"
unset -v exec_dfbk_lrs_lib_path


rga_after_num=1

dRGA_OPTION=$(\
		echo ${dRGA_OPTION} \
		| sed -re 's/-d([a-z]) /\ -\1\ /g'\
)
desk_rga_cmd=$(\
	echo_desk_rga_cmd \
		"${rga_after_num}"\
)
desk_rga_v_cmd=$(\
	echo_desk_rga_v_cmd \
		"${rga_after_num}"\
)
unset -v rga_after_num

case "${E_OPTION}" in
	"")
		display_merge_list_by_daily
		;;
	*)
		display_merge_list_by_every\
			"${desk_rga_cmd}" \
			"${desk_rga_v_cmd}"
		;;
esac
