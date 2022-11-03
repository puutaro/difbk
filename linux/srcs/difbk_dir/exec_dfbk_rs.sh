#!/bin/bash
IFS=$'\t'
rs_arg_list=($(echo "${DIFBK_ARGUMENT//[,\"]/	}"))
IFS=$' \n'

# merge and copy ------------------------------------------------------------------------------------------------------------------
get_buckup_file_path=$(echo "${rs_arg_list[0]}" | rga -e "^../${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}/${TARGET_DIR_NAME}" -e "^${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}/${TARGET_DIR_NAME}")
get_buckup_file_path="$(test -e "${get_buckup_file_path}" && echo "${get_buckup_file_path}" || e=$?)"
case "${get_buckup_file_path}" in
	"") ;;
	*)
	rm -rf "${DFBK_RESTORE_DIR_PATH}" && mkdir -p "${DFBK_RESTORE_DIR_PATH}"
	source_file_path="${rs_arg_list[0]}"
	source_file_deflost_path="${DFBK_RESTORE_DIR_PATH}/$(echo "${get_buckup_file_path}" | sed -e 's/^\.\.//' -re "s/([^a-zA-Z0-9_-])/_/g")"
	merge_cat_path="${DFBK_RESTORE_DIR_PATH}/merge_contents.txt"
	zcat "${source_file_path}" > "${source_file_deflost_path}"
	case "${rs_arg_list[1]}" in
		"")
			target_file_path=$(echo "${get_buckup_file_path}" | sed -e "s/^${SED_BUCK_UP_DIR_PATH}\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/${BACKUP_CREATE_DIR_NAME}\/${TARGET_DIR_NAME}\///g"  -e "s/^\.\.\/${BUCK_UP_DIR_NAME}\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/${BACKUP_CREATE_DIR_NAME}\/${TARGET_DIR_NAME}\///g" -e 's/'${SED_DFBK_GGIP_EXETEND}'$//g')
		;;
		*)
			target_file_path="${rs_arg_list[1]}"
			C_OPTION="-c"
		;;
	esac
	target_dir_path="$(dirname "${rs_arg_list[1]}")"	
	case "${target_dir_path}" in
		.) ;;	
		*) [ ! -e "${target_dir_path}" ] && mkdir -p "${target_dir_path}";;
	esac
	case "$(echo "${target_file_path}" | rga "${GGIP_EXETEND}$")" in "") ;; *) C_OPTION="-c";; esac
	case "${C_OPTION}" in
	"")
		merge -p -A "${source_file_deflost_path}" "${target_file_path}" "${source_file_deflost_path}" > ${merge_cat_path} || e=$?
		wait
		cat "${merge_cat_path}" > "${target_file_path}"
		wait
		rm "${source_file_deflost_path}" "${merge_cat_path}";;
	-c) 
		case "${rs_arg_list[1]}" in
			"")
				case "${target_dir_path}" in  
					.)
						target_dir_path="$(dirname "${target_file_path}")"
						[ ! -e "${target_dir_path}" ] && mkdir -p "${target_dir_path}"
						;;
				esac
			;;
		esac
		cp -avf "${source_file_deflost_path}" "${target_file_path}"
		wait;
		;;
	esac
	rm -rf "${DFBK_RESTORE_DIR_PATH}"
	exit 0
	;;
esac
# -------------------------------------------------------------------------------------------------------------------------------------

# restore start -----------------------------------------------------------------------------------------------
get_merge_list_specify="$(echo "${rs_arg_list[0]}" | rga -e "^../${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$" -e "^${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$" || e=$?)"
get_merge_list_specify="$(test -e "${get_merge_list_specify}" && echo "${get_merge_list_specify}" || e=$?)"
echo ${get_merge_list_specify}
case "${get_merge_list_specify}" in
"")
echo "no exist this merge list file path: ${rs_arg_list[0]}"
exit 0
;;
esac
if [ -z "${rs_arg_list[0]}" ] || [ -z "${rs_arg_list[1]}" ]; then exit 0;fi
echo "################################" 
restore_target_path="${rs_arg_list[1]}"
if [ -n "$(echo "${rs_arg_list[2]}")" ];then  
	grep_path=$(echo "${rs_arg_list[2]}" | sed -e 's/^'${SED_TARGET_PAR_DIR_PATH}'//g' -e 's/^\///g')
	# lecho "rs:0: ### grep_path: ${grep_path}"
	ls_buckup_merge_contents=$(zcat "${rs_arg_list[0]}" | rga "${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}/${TARGET_DIR_NAME}/${grep_path}" || e=$?);
	# lecho "ls_buckup_merge_contents :: $(echo "${ls_buckup_merge_contents}" | head -n 10)"
	# lecho "ls_buckup_merge_contents :: $(echo "${ls_buckup_merge_contents}" | wc -l | sed 's/\ //g')"
elif [ -z "$(echo "${rs_arg_list[2]}")" ];then  
	ls_buckup_merge_contents=$(zcat "${rs_arg_list[0]}");
fi
# echo "rs:1: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | head -n ${DISPLAY_NUM_LIST})"
# echo "rs:1: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | wc -l | sed 's/\ //g')"
# echo "${restore_target_path}/${TARGET_DIR_NAME}" | sed 's/\/\//\//g'
# ls ${restore_target_path}/${TARGET_DIR_NAME}
while [ true ]
do
	rs_tar_insert_dir_path=$(echo "${restore_target_path}/${TARGET_DIR_NAME}" | sed -e 's/\/\//\//g' -e 's/\/$//')
	if [ ! -d "${rs_tar_insert_dir_path}" ];then break;fi
	echo "delete directory ok?(y/n): ${rs_tar_insert_dir_path}"
	read -e confirm
	if [ "${confirm}" == "y" ];then 
		cd ../
		rm -rf "${rs_tar_insert_dir_path}" 
		# zero restore support (when old and .. in same par dir)
		[ ! -e "${DFBK_SETTING_DIR_PATH}" ] && mkdir -p "${DFBK_SETTING_DIR_PATH}"
		cd "${TARGET_DIR_PATH}"
		break;
	else
		exit 0
	fi
done
export BACKUP_CREATE_DIR_PATH="${restore_target_path}"
copy_exec "${ls_buckup_merge_contents}" "-u"
wait
echo "total: $(echo "${ls_buckup_merge_contents}" | wc -l | sed 's/\ //g')"
# -----------------------------------------------------------------------------------------------
exit 0