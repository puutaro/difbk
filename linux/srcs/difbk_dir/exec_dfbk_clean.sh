#!/bin/bash

clean_op_list=($(echo "${GENERAL_OPTION//[\,\']/}"))
if [ -z "${clean_op_list[0]}" ];then echo "first para no (-dddd:clean, -vl: mergelist validation)" ; exit 0 ;
elif [ "${clean_op_list[0]}" == "-dddd" ];then validation_merge_list="" ;
elif [ "${clean_op_list[0]}" == "-vl" ];then validation_merge_list="${clean_op_list[0]}" ;fi
if [ -z "${validation_merge_list}" ] && [ -z "${clean_op_list[1]}" ];then echo "no second para (base regester date)"; exit 0;fi
if [ ${clean_op_list[1]} -gt 0 ] 2>/dev/null;then base_register_date_order=${clean_op_list[1]};
elif [ -z "${validation_merge_list}" ];then echo "no second para nomeric (base regester date)"; exit 0;fi
# lecho "### clean:-2: base_register_date_order: ${base_register_date_order}"

# get merge file list -------------------------------------------------------------
base_register_date_order=$((${base_register_date_order} + 1))
if [ -n "${validation_merge_list}" ];then
	#base_register_merge_file_list=$(diffbk_lrs -d ${base_register_date_order} ${base_register_date_order} | rga -v "${DESC_PREFIX}" | rga \["[0-9]{1,10}"\] | cut -f2 | sort -r)
	base_register_merge_file_list=$(fd . "${BUCK_UP_DIR_PATH}" -d 6 -t f | rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | sort -r | sed -r "s/^(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})/\2\t\1/" | uniq -f 1  | sed -r "s/^(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})\t(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})/\2\1/" | head -n ${base_register_date_order})
else
	#base_register_merge_file_list=$(diffbk_lrs -d -${base_register_date_order} ${base_register_date_order} | rga -v "${DESC_PREFIX}" | rga \["[0-9]{1,10}"\] | cut -f2 | sort )
	base_register_merge_file_list=$(fd . "${BUCK_UP_DIR_PATH}" -d 6 -t f | rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | sort | sed -r "s/^(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})/\2\t\1/" | uniq -f 1 | sed -r "s/^(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})\t(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})/\2\1/" | sort -r | head -n ${base_register_date_order} | sort )
fi
# ------------------------------------------------------------------------------------

order_base_register_merge_file_list=$(echo "${base_register_merge_file_list}" | wc -l | sed 's/\ //g')
if [ -z "${base_register_merge_file_list}" ];then echo "no exist target register_merge_file"; exit 0; fi
if [ -z "${validation_merge_list}" ] && [ ${base_register_date_order} -gt ${order_base_register_merge_file_list} ];then echo "cant't leave ( save data num: ${order_base_register_merge_file_list}"; exit 0; fi
if [ -z "${validation_merge_list}" ] && [ ${order_base_register_merge_file_list} -le ${LIMIT_DELETE_MERGE_FILE_NUM} ];then echo "you can't clean over register day limit : ${LIMIT_DELETE_MERGE_FILE_NUM})"; exit 0; fi
base_register_merge_list_path=$(echo "${base_register_merge_file_list}" | head -n 1)
# lecho "clean:-2: base_register_merge_list_path: ${base_register_merge_list_path}"
if [ ! -e "${base_register_merge_list_path}" ];then echo "no list_file"; exit 0;fi
base_list_source=$(zcat ${base_register_merge_list_path})
base_list_cont=$(echo "${base_list_source}" | cut -f2)
# lecho "### clean:0: base_list_cont: $(echo "${base_list_cont}" | head -n ${DISPLAY_NUM_LIST})"
# lecho "### clean:0: base_list_cont: $(echo "${base_list_cont}" | wc -l | sed 's/\ //g')"
grep_base_rgi_path=$(echo ${base_register_merge_list_path} |  sed -e 's/^'${SED_TARGET_PAR_DIR_PATH}'\//\//' -e 's/\/[0-9]\{4\}\/'${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}'.*//')
sed_grep_base_rgi_path=$(echo "${grep_base_rgi_path}" | sed 's/\//\\\//g')
# lecho "### clean:0: base_register_merge_list_path: $(echo "${base_register_merge_list_path}" | head -n ${DISPLAY_NUM_LIST})"
# lecho "### clean:0: base_register_merge_list_path: $(echo "${base_register_merge_list_path}" | wc -l | sed 's/\ //g')"
day_depth_path_list=$(fd  -t d --max-depth 3 . ${BUCK_UP_DIR_PATH} | rga "${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}" | sort)
echo "### clean:0: day_depth_path_list: $(echo "${day_depth_path_list}"  | tail -n 30)"
echo "### clean:0: day_depth_path_list: $(echo "${day_depth_path_list}" | wc -l | sed 's/\ //g')"

if [ -n "${validation_merge_list}" ];then
	delete_row_num=$(echo "${day_depth_path_list}"  | sed -n '/'${sed_grep_base_rgi_path}'/=')
	day_depth_path_list=$(echo "${day_depth_path_list}"  | sed -n '1,'${delete_row_num}'p')
else
	day_depth_path_list=$(echo "${day_depth_path_list}"  | sed -n '/'${sed_grep_base_rgi_path}'/,$!p')
fi
# lecho "### clean:1: day_depth_path_list: $(echo "${day_depth_path_list}" | head -n 30)"
# lecho "### clean:1: day_depth_path_list: $(echo "${day_depth_path_list}" | wc -l | sed 's/\ //g')"
IFS=$'\n'
day_depth_path_list_l=($(echo "${day_depth_path_list}"))
IFS=$' \n'
buck_up_data_list=$(LANG=C fd -IH . "${day_depth_path_list_l[@]}" | sed 's/^'${SED_TARGET_PAR_DIR_PATH}'//' | sort | uniq ) 
# lecho "### clean:1: buck_up_data_list: $(echo "${buck_up_data_list}"  | head -n ${DISPLAY_NUM_LIST})"
# lecho "### clean:1:buck_up_data_list: $(echo "${buck_up_data_list}" | wc -l | sed 's/\ //g')"
if [ -n "${validation_merge_list}" ]; then
	delete_list=$(join -v 2  <(echo "${buck_up_data_list}" | sed -e 's/'${DFBK_GGIP_EXETEND}'//' -e 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort ) <(echo "${base_list_cont}" | sed 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort) | sed 's/^/99999\t/g' | sed 's/'${DIFBK_BLANK_MARK}'/\ /g')
	if [ -z "${delete_list}" ];then echo "it's correct (${base_register_merge_list_path}"; exit 0; fi
	modify_merge_list="${base_list_source}"
	echo "### clean:1: delete_list: $(echo "${delete_list}" | head -n ${DISPLAY_NUM_LIST})"
	echo "### clean:1:delete_list: $(echo "${delete_list}" | wc -l)"
	echo "### clean:1: modify_merge_list: $(echo "${modify_merge_list}" | head -n ${DISPLAY_NUM_LIST})"
	echo "### clean:1:modify_merge_list: $(echo "${modify_merge_list}" | wc -l | sed 's/\ //g')"
	if [ -n "${delete_list}" ];then
		delete_list_mark="DLDLDLDLDLDLDL"
		modify_merge_list=$(cat <(echo "${delete_list}" | sed -r "s/^([0-9d]{1,20})\t/${delete_list_mark}\t/") <(echo "${modify_merge_list}") | sort -k 2,2 | uniq -u -f 1 | rga -v "^${delete_list_mark}\t")
	fi
	#modify_merge_list=$(remove_row_path_from_contents_eval_big "${delete_list}" "${modify_merge_list}")
	# echo "### clean:2:modify_merge_list: $(echo "${modify_merge_list}" | head -n ${DISPLAY_NUM_LIST})"
	# echo "### clean:2:modify_merge_list: $(echo "${modify_merge_list}" | wc -l | sed 's/\ //g')"
	echo "${modify_merge_list}" | gzip -c > ${base_register_merge_list_path}
	if [ -n "${delete_list}" ];then 
		echo "modify (it's incorrect (${base_register_merge_list_path}"; 
		echo "delete_path_list"
		echo "${delete_list}" | cut -f2 | head -n ${DISPLAY_NUM_LIST}
		echo "total_delete: $(echo "${delete_list}" | wc -l | sed 's/\ //g')"
	fi
	exit 0
fi
# lecho "### clean:2: base_list_cont: $(echo "${base_list_cont}" | head -n ${DISPLAY_NUM_LIST})"
# lecho "### clean:2: base_list_cont: $(echo "${base_list_cont}" | wc -l | sed 's/\ //g')"
# lecho "### clean:2: buck_up_data_list: $(echo "${buck_up_data_list}"  | head -n ${DISPLAY_NUM_LIST})"
# lecho "### clean:2:buck_up_data_list: $(echo "${buck_up_data_list}" | wc -l)"
clean_list=$(join -v 1  <(echo "${buck_up_data_list}" | sed 's/'${SED_DFBK_GGIP_EXETEND}'//g' | sed 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort ) <(echo "${base_list_cont}" | sed 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort)  | sed 's/'${DIFBK_BLANK_MARK}'/\ /g')
echo "### clean:2: clean_list: $(echo "${clean_list}" | head -n 10)"
echo "### clean:2:clean_list: ${clean_num}"

clean_num=$(echo "${clean_list}" | wc -l)
echo "${clean_list}" | sed 's/^/'${SED_TARGET_PAR_DIR_PATH}'/g' | xargs -P ${ENV_PARARELL_EXEMNUM} -d'\n'  -I{} bash -c "exec_delete_gzip \"{}\"" | pv
echo "[1/3] finished clean (clean file or dir num : ${clean_num})"

# lecho "### clean:2: base_list_cont: $(echo "${base_list_cont}" | head -n ${DISPLAY_NUM_LIST})"
# lecho "### clean:2: base_list_cont: $(echo "${base_list_cont}" | wc -l | sed 's/\ //g')"
base_list_cont_old_day=$(echo "${base_list_cont}" | rga -o "^/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}" | sed 's/^\/'${BUCK_UP_DIR_NAME}'\//'${SED_BUCK_UP_DIR_PATH}'\//' | sort | uniq | head -n 1)
echo "save dir most old day: ${base_list_cont_old_day}"
# lecho "### clean:3: base_list_cont_old_day: $(echo "${base_list_cont_old_day}" )"
# lecho "### clean:3: base_list_cont_old_day: $(echo "${base_list_cont_old_day}" | wc -l | sed 's/\ //g')"
substitute_day_depth_path=$(cat <(echo "${day_depth_path_list}")  <(echo "${base_list_cont_old_day}") | sort | uniq)
# lecho "### clean:3: substitute_day_depth_path: $(echo "${substitute_day_depth_path}" )"
# lecho "### clean:3: substitute_day_depth_path: $(echo "${substitute_day_depth_path}" | wc -l | sed 's/\ //g')"
# sed_base_list_cont_old_day=$(echo "${base_list_cont_old_day}" | sed 's/\//\\\//g')
IFS=$'\n'
substitute_day_depth_path_list=($(echo "${substitute_day_depth_path}"))
IFS=$' \n'
# lecho "### clean:4: substitute_day_depth_path: $(echo "${substitute_day_depth_path_list[@]}")"
# lecho "### clean:4: substitute_day_depth_path: $(echo "${#substitute_day_depth_path_list[@]}")"
echo "[2/3]  empty dir day bellow dir delete"
while [ true ]
do
	if [ -z "${substitute_day_depth_path_list}" ];then break ;fi
	empty_dir_list=$(find "${substitute_day_depth_path_list[@]}"  -type d -empty)
	if [ -z "${empty_dir_list}" ];then break ;fi
	echo "${empty_dir_list}" | xargs  -P ${ENV_PARARELL_EXEMNUM} -d'\n'  -I{} bash -c "exec_delete_gzip \"{}\""
done
# lecho "### clean:3: empty_dir_list: $(echo "${empty_dir_list}" | head -n ${DISPLAY_NUM_LIST})"
# lecho "### clean:3:empty_dir_list: $(echo "${empty_dir_list}" | wc -l | sed 's/\ //g')"

echo "[3/3] empty top dir bellow delete"
while [ true ]
do
	top_empty_dir_list=$(find ${BUCK_UP_DIR_PATH} -maxdepth 5 -type d -empty)
	if [ -z "${top_empty_dir_list}" ];then break ;fi
	echo "${top_empty_dir_list}" | xargs -P ${ENV_PARARELL_EXEMNUM} -d'\n'  -I{} rm -rf "{}"
done
echo "clean complete !"
