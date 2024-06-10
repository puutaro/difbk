#!/bin/bash


exec_dfbk_reset_lib_path="${DIFBK_LIB_DIR_PATH}/exec_dfbk_reset_lib"
. "${exec_dfbk_reset_lib_path}/echo_recent_backup_datetime_directory_path.sh"
. "${exec_dfbk_reset_lib_path}/reset_confirm.sh"
unset -v exec_dfbk_reset_lib_path


delete_recent_datetime_bkdir="..$(\
	echo_recent_backup_datetime_directory_path\
)"

case "${delete_recent_datetime_bkdir}" in
	"..") exit 0 ;;esac

case "${S_OPTION}" in
	"") reset_confirm \
			"${delete_recent_datetime_bkdir}"
		;;
esac

rm -rf "${delete_recent_datetime_bkdir}"
echo "delete_recent_datetime_bkdir ${delete_recent_datetime_bkdir}"