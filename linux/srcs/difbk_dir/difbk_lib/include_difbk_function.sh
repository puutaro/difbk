#!/bin/bash

read_opt_val(){
	echo "${1}" | grep "\-${2}" | sed -e 's/^\-'${2}'//' -e "s/'//g" | sed 's/^\s*//'
}

replace_desti_path(){
	cat "/dev/stdin"  | sed -r "s/^(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})\/${TARGET_DIR_NAME}/\1\/${1}/" | sed "s/\/\//\//g" | sed "s/^\/${BUCK_UP_DIR_NAME}/\/${2}/" | sed "s/\/\//\//g"
}

insert_row_path_from_contents(){
	INSERTED_CONTENTS=""
	sed_buck_up_create_dir_ralative_path=$(echo "${BUCK_UP_CREATE_DIR_RALATIVE_PATH}" | sed 's/\//\\\//g')
	insert_contents=$(echo "${2}"| sed 's/\t\/'${TARGET_DIR_NAME}'\//\t'${sed_buck_up_create_dir_ralative_path}'\/'${TARGET_DIR_NAME}'\//g' | sed 's/\t\/'${TARGET_DIR_NAME}'$/\t'${sed_buck_up_create_dir_ralative_path}'\/'${TARGET_DIR_NAME}'/g')
	INSERTED_CONTENTS=$(cat <(echo "${1}") <(echo "${insert_contents}") | sed '/^$/d')
}


make_delete_list_by_grep(){
	local buck_up_path_list="${1}"
	local grep_list="${2}"
	local source_rgi_path="${3}"
	local sed_grep_base_rgi_path=$(echo "${3}" | sed 's/\//\\\//g')
	for gli in ${grep_list}
	do
		output_con=$(echo "${buck_up_path_list}" | grep "${gli}")
		if [ -z "$(echo "${output_con}" | grep ${source_rgi_path})" ];then continue;fi
		if [ "${gli}" == "/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" ] || [ "${gli}" == "/${BUCKUP_DESC_FILE_NAME}" ];then
			echo "${output_con}" | grep "${gli}" | sed -n '/'${sed_grep_base_rgi_path}'/,$!p'  &
		else
			echo "${output_con}" | grep -E "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}${gli}$" | sed -n '/'${sed_grep_base_rgi_path}'/,$!p'  &
		fi
	done
	wait
}


exclude_bkup_func(){
	grep_contents_list=($(cat "${DFBK_IGNORE_FILE_PATH}"))
	for gw in ${grep_contents_list}
	do
		echo "${2}"  | grep $'\t'"${1}" &
	done
	wait
}

make_desk_rga_comd(){
	case "${D_OPTION}" in 
	",\"\"") 
		local desk_rga_cmd=""
		;;
	"")
		case "${dRGA_OPTION}" in
			"")
				desk_rga_cmd="";;
			*)
				desk_rga_cmd=" | rga -A ${1} ${dRGA_OPTION}";;
		esac
		;;
	*)
		case "${2}" in
			"")
				local desk_rga_cmd=$(echo ${D_OPTION} | sed -re "s/(${DESC_PREFIX})/\" | rga -A ${1} ${dRGA_OPTION} \"\1/g" -e 's/^"//' -e 's/$/"/' )
				;;
			*)
				local desk_rga_cmd=$(echo ${D_OPTION} | sed -re "s/(${DESC_PREFIX})/\" | rga -A ${1} ${dRGA_OPTION} \"\\\[2\\\] \1/g" -e 's/^"//' -e 's/$/"/' )
				;;
		esac
		;;
	esac
	echo "${desk_rga_cmd}"

}

make_desk_rga_v_comd(){
	case "${DV_OPTION}" in 
	",\"\""|"") 
		local desk_rga_v_cmd="" ;;
	*)
		case "${2}" in
			"")
				local desk_rga_v_cmd=$(echo ${DV_OPTION} | sed -re "s/,(${DESC_PREFIX})\.\*([^,]{1,100})/ | sed '\/\1.*\2\/,+${1}d'/g")
				;;
			*)
				local desk_rga_v_cmd=$(echo ${DV_OPTION} | sed -re "s/,(${DESC_PREFIX})\.\*([^,]{1,100})/ | sed '\/\\\[2\\\] \1.*\2\/,+${1}d'/g")
		esac
		;;
	esac
	echo "${desk_rga_v_cmd}"
}

desk_cat_func(){
	LANG=C
	rm -rf "${DFBK_DESK_RECIEVE_DIR_PATH}" "${DFBK_DESK_RECIEVE_FILE_PATH}"
	mkdir -p "${DFBK_DESK_RECIEVE_DIR_PATH}"
	sed_dfbk_desk_recieve_dir_path=$(echo "${DFBK_DESK_RECIEVE_DIR_PATH}" | sed 's/\//\\\//g')
	sed_dfbk_desk_recieve_file_path=$(echo "${DFBK_DESK_RECIEVE_FILE_PATH}" | sed 's/\//\\\//g')
	# make desk cat file ----------------------------------------------------
	echo "${1}" | sed -e 's/'${BACKUP_CREATE_DIR_NAME}'.*/'${BUCKUP_DESC_FILE_NAME}'/' -re 's/^(.*)/"\1" /' | sed 's/$/ \\/' | awk -v DFBK_DESK_RECIEVE_DIR_PATH="${DFBK_DESK_RECIEVE_DIR_PATH}"  '(NR%50==0){ printf "%s\n >   ""\042"DFBK_DESK_RECIEVE_DIR_PATH"/""desk_con_%024d""\042"" 2>&1 & \n head -qn 1 ",$0,NR}(NR%50!=0){print}' | sed '1ihead -qn 1 \\' | sed "$ s/\\\\$/ > \"${sed_dfbk_desk_recieve_dir_path}\/desk_con_9${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}\"  2\>\&1 \&/" | sed '$ s/head -qn 1//' | sed '$ a wait' > "${DFBK_DESK_CAT_FILE_PATH}" && LANG=C bash "${DFBK_DESK_CAT_FILE_PATH}" || e=$?
	fd -t f . "${DFBK_DESK_RECIEVE_DIR_PATH}" | sed -e '/^$/d' -e "s/^/\"/" -e "s/$/\" \\\\/" -e '1i cat \\' | awk -v DFBK_DESK_RECIEVE_FILE_PATH=${DFBK_DESK_RECIEVE_FILE_PATH} '(NR%20==0){$0=$0"\n;cat ""\\"}{print}' | sed '$s/^\;cat \\//' > "${DFBK_DESK_OUTPUT_FILE_PATH}" && bash "${DFBK_DESK_OUTPUT_FILE_PATH}" | sed 's/.*No such\sfile\sor\sdirectory.*/-/'
}

make_before_and_after_delete(){
	case "${2}" in "");; *) diff_prefix='\[2\] ';; esac
	case "${1}" in "") ;; *) local diff_delete_sed=" | sed '1,${1}d'";;esac
	case "${DB_OPTION}" in "");; *) 
		local sed_db_option=$(echo ${DB_OPTION} | sed  's/\//\\\//g')
		local before_delete_cmd=" | sed -n '/${diff_prefix}${sed_db_option}/,\$!p'";;esac
	case "${DA_OPTION}" in "");; *) 
		local sed_da_option=$(echo ${DA_OPTION}  | sed  's/\//\\\//g')
		local after_delete_cmd=" | sed -n '1,/${diff_prefix}${sed_da_option}/!p' ${diff_delete_sed}";;esac
	echo "${before_delete_cmd} ${after_delete_cmd}"
}
