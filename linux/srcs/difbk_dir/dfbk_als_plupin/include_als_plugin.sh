#!/bin/bash
extend_disp_range=$((${disp_list_num} - 2))
echo "## best_path_word(search_extend) %,  average file row"
header=""
every_con_num_matrx=""
buck_up_data_list_als=$(LANG=C fd -IH . "${day_depth_path_list_l[@]}" -t f --size -5M | sed '/^$/d'  | sed 's/^'${SED_TARGET_PAR_DIR_PATH}'//' | sort | uniq | rga -v "/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}" | rga "^/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}" || e=$?)

for i in $(seq 1 ${extend_disp_range})
do
	#echo ${extend_disp_range}
	pt_ex_per_con_list=""
	part_every_con_num_matrx=""
	part_every_con_num_matrx_extend=""
	search_path_word=$(echo "${best_path_word}" | awk '{print $2}'| sed -n "${i}p")
	zenkaku_f=$(echo "${search_path_word}" | LANG=C rga -n -v '^[[:cntrl:][:print:]]*$' || e=$?)
	lecho "zenkaku_f: ${zenkaku_f}"
	if [ -n "${zenkaku_f}" ];then continue;fi
	search_path_word_list[i]=$(echo "${search_path_word}")
	lecho "search_path_word: ${search_path_word}"
	for j in $(seq 1 ${extend_disp_range})
	do
		extend_list=$(echo "${best_extend}" | awk '{print $2}')
		lecho ${extend_list[@]}
		search_extend=$(echo "${extend_list}" | sed -n "${j}p")
		lecho "search_extend: ${search_extend}"
		seach_col_name="${search_extend}"
		lecho "seach_col_name: ${seach_col_name}"
		if [ -z "$(echo "${seach_col_name}")" ];then break; fi
		if [ ${i} -eq 1 ];then  header=$(paste <(echo "${header}") <(echo "${seach_col_name}")); fi
		num_search_path_word=$(echo "${buck_up_data_list_als}" | rga "${search_path_word}" | wc -l | sed 's/\ //g')
		lecho "num_search_path_word:${num_search_path_word}"
		lecho "buck_up_data_list_als: ${buck_up_data_list_als}" | head -n 10
		num_search_extend_word=$(echo "${buck_up_data_list_als}" | rga "${search_path_word}" | rga  "\.${search_extend}${DFBK_GGIP_EXETEND}$" | wc -l | sed 's/\ //g')
		lecho "num_search_extend_word: ${num_search_extend_word}"
		if [ ${num_search_path_word} -le 0 ] || [ ${num_search_extend_word} -le 0 ];then continue ;fi
		con_path=$(echo "${buck_up_data_list_als}"  | rga "${search_path_word}" | rga "\.${search_extend}${DFBK_GGIP_EXETEND}$" | sed 's/^/'${SED_TARGET_PAR_DIR_PATH}'/g' || e=$?)
		#echo "con_path: ${con_path}"
		con=$(echo "${con_path}" | gxargs -P ${ENV_PARARELL_EXEMNUM} -d'\n'  -I{} bash -c "zip_cat_check_dir_path \"{}\"")
		every_con_num_list=$(echo "${con_path}" | gxargs -P ${ENV_PARARELL_EXEMNUM} -d'\n'  -I{} bash -c "zip_cat_wc_check_dir_path \"{}\"" | sort -r)
		every_con_num_list_extend=$(cat <(echo "${seach_col_name}") <(echo "${every_con_num_list}"))
		every_con_num_list_extend=$(trace_matrix  "${every_con_num_list_extend}")
		if [ ${i} -eq 1 ];then every_con_num_list=$(cat <(echo "${seach_col_name}") <(echo "${every_con_num_list}")) ;fi # 
		con_num=$(echo "${con}" | wc -l | sed 's/\ //g')
		if [ ${num_search_extend_word} -eq 0 ];then num_search_extend_word=1;fi
		av_row_num=$(( ${con_num} / ${num_search_extend_word} ))
		pt=$(( (${num_search_extend_word}*100) / ${num_search_path_word}))
		pt_ex_per_con=$(echo "${pt}%:${search_path_word}(${search_extend}), ${av_row_num}:${search_extend}_av_row" \|\ )
		pt_ex_per_con_list=$(cat <(echo "${pt_ex_per_con_list}") <(echo "${pt_ex_per_con}"))
		every_con_num_list=$(trace_matrix  "${every_con_num_list}")

		part_every_con_num_matrx=$(cat <(echo "${part_every_con_num_matrx}") <(echo "${every_con_num_list}"))
		eval "every_con_num_matrx_${search_path_word}=\$(cat <(echo \"\${every_con_num_matrx_${search_path_word}}\") <(echo \"\${every_con_num_list_extend}\"))"
	done
	echo ${pt_ex_per_con_list} | sed '/^$/d'
	every_con_num_matrx=$(paste <(echo "${every_con_num_matrx}") <(echo "${part_every_con_num_matrx}"))
done
echo "${SEPARATE_BAR}"
lecho "every_con_num_matrx: ${every_con_num_matrx}"
# eval "display_culc_co_matrix \"\${every_con_num_matrx_lambda}\" \"lambda\""
eval "display_culc_co_matrix \"\${every_con_num_matrx}\" \"total\""
header_list=($(echo "${every_con_num_matrx}" | sort -rk 1,1 | head -n 1))
for hl in ${search_path_word_list[@]}
do
	zenkaku=$(echo "${hl}" | LANG=C rga -n -v '^[[:cntrl:][:print:]]*$' )
	if [ -n "${zenkaku}" ];then continue;fi
	echo "${SEPARATE_BAR}"
	eval "display_culc_co_matrix \"\${every_con_num_matrx_${hl}}\" \"${hl}\""
done
echo ${SEPARATE_BAR}
