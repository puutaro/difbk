#!/bin/bash
reverse_on=0
# register_date_range setting
if [ -z "${2}" ];then register_date_range=30;
elif [ ${2} -lt 0 ];then register_date_range=${2};
elif [ ${2} -gt 0 ];then register_date_range=${2};
else register_date_range=30; fi
	if [ -z "${3}" ];then disp_list_num=5;
elif [ ${3} -gt 0 ];then disp_list_num=${3};
else disp_list_num=5; fi
disp_list_num=$(echo "${disp_list_num}" | sed 's/^-//')
long_disp_list_num=$((${disp_list_num} * 2))
if [ ${disp_list_num} -le 5 ];then detail_switch="";
else detail_switch="on";fi
if [ ${disp_list_num} -gt 10 ];then disp_list_num=10 ;fi
register_date_range=$(echo "${register_date_range}" | sed 's/^-//')
# reverse setting
if [ -n "${2}" ] && [ "${register_date_range}" != "${2}" ];then reverse_on=1; fi
if [ -z "${2}" ];then register_date_range=30 ;fi
#title alter
if [ ${reverse_on} -eq 0 ];then tilte_words="best"; 
else tilte_words="least"; fi
day_depth_path_list=$(fd -IH -t d . ${BUCK_UP_DIR_PATH} -d 3 | rga "[0-9]{4}/[0-9]{2}/[0-9]{2}" | sort -r | head -n ${register_date_range})
als_disp_contents=$(cat <(echo "${SEPARATE_BAR}") <(echo "${tilte_words} search for ${register_date_range} recent register date") | sed '/^$/d')

IFS=$'\n'
day_depth_path_list_l=($(echo "${day_depth_path_list}"))
IFS=$' \n'
# best_recent_edit
if [ ${reverse_on} -eq 0 ];then
	best_recent_edit=$(fd -IH . "${day_depth_path_list_l[@]}" --type f | rga -v ".DS_Store$" | rga -v "/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | gxargs -P ${PARARELL_EXEMNUM} -d'\n' -I{} gls --full-time "{}" | sed 's/\-/\//g' |  awk '{print $6"/"$7"\t"$9}' | sort -r | head -n ${disp_list_num} | rga -o "/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/.*"  | sed 's/^'${SED_TARGET_PAR_DIR_PATH}'\/'${BUCK_UP_DIR_NAME}'//g' | sed 's/'${DFBK_GGIP_EXETEND}'//')
else  
	best_recent_edit=$(fd -IH . "${day_depth_path_list_l[@]}" --type f | rga -v ".DS_Store$" | rga -v "/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | gxargs -P ${PARARELL_EXEMNUM} -d'\n' -I{} gls --full-time "{}" | sed 's/\-/\//g' |  awk '{print $6"/"$7"\t"$9}' | sort | head -n ${disp_list_num} | rga -o "/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/.*"  | sed 's/^'${SED_TARGET_PAR_DIR_PATH}'\/'${BUCK_UP_DIR_NAME}'//g' | sed 's/'${DFBK_GGIP_EXETEND}'//')
fi

#Local/Auto
als_disp_contents=$(cat <(echo "${als_disp_contents}") <(echo "### ${tilte_words}_recent_edit") <(echo "${best_recent_edit}") | sed '/^$/d')


# display_best_write_file
buck_up_data_list=$(LANG=C fd -IH . "${day_depth_path_list_l[@]}" --type f | rga -v ".DS_Store$" | rga -v "/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | sed '/^$/d'  | sed 's/^'${SED_TARGET_PAR_DIR_PATH}'//' | sort | uniq  | rga -v "/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}" | rga "^/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}" || e=$?)
#echo_file_path
if [ ${reverse_on} -eq 0 ];then
	best_write_file=$(echo "${buck_up_data_list}" | sed 's/^\/'${BUCK_UP_DIR_NAME}'\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/'${BACKUP_CREATE_DIR_NAME}'\//\//' | sed 's/'${DFBK_GGIP_EXETEND}'//' | sort | uniq -c | sort -r )
else  
	best_write_file=$(echo "${buck_up_data_list}" | sed 's/^\/'${BUCK_UP_DIR_NAME}'\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/'${BACKUP_CREATE_DIR_NAME}'\//\//' | sed 's/'${DFBK_GGIP_EXETEND}'//' | sort | uniq -c | sort)
fi
display_best_write_file="${best_write_file}"
als_disp_contents=$(cat <(echo "${als_disp_contents}") <(echo "### ${tilte_words}_write_file:") <(echo "${display_best_write_file}" | head -n ${disp_list_num}) | sed '/^$/d')

# best_extend
source_best_extend=$(echo "${best_write_file}" | rga "\.[a-z]{1,6}$" | sed 's/.*\.//g')
if [ ${reverse_on} -eq 0 ];then
	best_extend=$(echo "${source_best_extend}" | sort  | uniq -c | sort -r | head -n ${long_disp_list_num})
else  
	best_extend=$(echo "${source_best_extend}" | sort  | uniq -c | sort  | head -n ${long_disp_list_num})
fi
als_disp_contents=$(cat <(echo "${als_disp_contents}") <(echo "### ${tilte_words}_extend:") <(echo ${best_extend}) | sed '/^$/d')


# best_path_word
best_path_word=$(echo "${best_write_file}" | sed 's/[/_-]/\n/g')
if [ ${reverse_on} -eq 0 ];then
	best_path_word=$(echo "${best_path_word}" | rga -v "[0-9]{1,4}" | sed '/^$/d' | rga -v "\.[a-zA-Z]{1,6}$" | sort | uniq -c | sort -r  | head -n ${long_disp_list_num})
else  
	best_path_word=$(echo "${best_path_word}" | rga -v "[0-9]{1,4}" | sed '/^$/d' | rga -v "\.[a-zA-Z]{1,6}$" | sort | uniq -c | sort | head -n ${long_disp_list_num})
fi

als_disp_contents=$(cat <(echo "${als_disp_contents}") <(echo "### ${tilte_words}_path_word:") <(echo ${best_path_word::300}) | sed '/^$/d')


if [ -n "${detail_switch}" ] && [ ${reverse_on} -eq 0 ];then
	als_disp_contents=$(cat <(echo "${als_disp_contents}") <(. ${DIFBK_ALS_PLUGIN_DIR_NAME}/include_als_plugin.sh) | sed '/^$/d')
fi

# best_size_date
best_size_date=$(echo "${day_depth_path_list}" | gxargs -P ${ENV_PARARELL_EXEMNUM} -d'\n'  -I{} bash -c "du_dir_check_exist_path \"{}\"" |  gsed -E ':l; s/^([0-9]+)([0-9]{3})/\1,\2/; t l;')
if [ ${reverse_on} -eq 0 ];then
	best_size_date=$(echo "${best_size_date}"  | rga -v "/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | rga -v ${BUCKUP_DESC_FILE_NAME} | sed 's/\t'${SED_BUCK_UP_DIR_PATH}'\//\t/' | sort -rn | head -n ${disp_list_num})
else
	best_size_date=$(echo "${best_size_date}" | rga -v "/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | rga -v ${BUCKUP_DESC_FILE_NAME} | sed 's/\t'${SED_BUCK_UP_DIR_PATH}'\//\t/' | sort -n | head -n ${disp_list_num})
fi
als_disp_contents=$(cat <(echo "${als_disp_contents}") <(echo "### ${tilte_words}_size_date:")  <(echo ${best_size_date}  | column -t) | sed '/^$/d')
# best_file_size
if [ ${reverse_on} -eq 0 ];then
	best_file_size=$(fd -IH . "${day_depth_path_list_l[@]}" --type f | gxargs -d'\n' -P "${ENV_PARARELL_EXEMNUM}" -I{} du -s "{}" |  gsed -E ':l; s/^([0-9]+)([0-9]{3})/\1,\2/; t l;' | rga -v "/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | rga -v ${BUCKUP_DESC_FILE_NAME} | sort -rn |  sed 's/'${SED_BUCK_UP_DIR_PATH}'\///g')
else
	best_file_size=$(fd -IH . "${day_depth_path_list_l[@]}" --type f | gxargs -d'\n' -P "${ENV_PARARELL_EXEMNUM}" -I{} du -s "{}" |  gsed -E ':l; s/^([0-9]+)([0-9]{3})/\1,\2/; t l;' | rga -v "/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | rga -v ${BUCKUP_DESC_FILE_NAME} | sort -n |  sed 's/'${SED_BUCK_UP_DIR_PATH}'\///g')
fi
als_disp_contents=$(cat <(echo "${als_disp_contents}") <(echo "### ${tilte_words}_size_file:")  <(echo "${best_file_size}" | head -n ${disp_list_num}  | column -t) | sed '/^$/d')
LANG="ja_JP.UTF-8" echo "${als_disp_contents}" | sed -r "s/(\/[0-9]{4})/\x1b[38;5;0m\1\x1b[0m/gi" | sed -r "s/(^### .*)/\x1b[1;38;5;2m\1\x1b[0m/gi" | sed -r "s/(^# .*)/\x1b[1;38;5;2m\1\x1b[0m/gi" | sed -r "s/(^## .*)/\x1b[1;38;5;2m\1\x1b[0m/gi" | sed -r "s/([0-9]{1,6}\ )/\x1b[1;38;5;20m\1\x1b[0m/g" | sed -r "s/([0-9]{1,3},)/\x1b[1;38;5;20m\1\x1b[0m/g" | sed -r "s/([0-9]{1,3}%)/\x1b[1;38;5;20m\1\x1b[0m/g" | sed -r "s/(\ [0-9]{1,10})\:/\x1b[1;38;5;20m\1\x1b[0m\:/g" | less -XR 