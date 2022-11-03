#!/bin/bash

display_culc_co_matrix(){
	lecho "tr_fuc_matrx_num: ${1}"
	local fuc_matrix=$(echo "${1}" | sed '/^$/d')
	local fuc_matrix_tr=$(trace_matrix "${fuc_matrix}")
	local header_list=($(echo "${fuc_matrix_tr}" | sort -rk 1,1 | head -n 1))
	local fuc_title="${2}"
	lecho "$(echo "${fuc_matrix}" | wc -l | sd '\s' '')"
	lecho "$(echo "${fuc_matrix}" | head -n ${DISPLAY_NUM_LIST})"
	lecho "$(echo "${fuc_matrix}"  | wc -l | sd '\s' '')"
	# culculate avarage table
	if [ ${extend_disp_range} -gt ${#header_list[@]} ];then extend_disp_range=${#header_list[@]} ;fi
	for i in $(seq 1 ${extend_disp_range})
	do
		local header_el="${header_list[$((i - 1))]}"
		local tr_fuc_matrx=$(trace_matrix "$(echo "${fuc_matrix}" | rga "${header_el}")" | sed '1d')
		local tr_fuc_matrx_num=$(echo ${tr_fuc_matrx} | wc -w | sd '\s' '')
		lecho "${tr_fuc_matrx_num}"
		lecho "tr_fuc_matrx_num: ${tr_fuc_matrx_num}"
		lecho "tr_fuc_matrx: ${tr_fuc_matrx}"
		local base_static_line=$(echo "${tr_fuc_matrx}" | awk -v header_el="${header_el}" -v row_num=${tr_fuc_matrx_num} '
				BEGIN {
			        OFS="\t" #タブ区切りの出力を設定している
			        cl_num=1; min=1000000
			    }
				{
					if($cl_num > 0) {
						if ( max < $cl_num ) max=$cl_num;
						if ( min > $cl_num ) min=$cl_num;
						sum+=$cl_num;
						if($cl_num > 0){ row++};
					}
				} 
				END {
					if(row > 0) print header_el, row_num, min, max, sum, sum/row;
					else print header_el, 0, "-", "-", "-", "-";
				}'
			)
		local base_static_info=$(cat <(echo "${base_static_info}") <(echo "${base_static_line}") | sed '/^$/d')
	done
	lecho "base_static_info"
	lecho "${base_static_info}"
	# culculate variance table
	for i in $(seq 1 ${extend_disp_range})
	do
		local header_el="${header_list[$((i - 1))]}"
		local tr_fuc_matrx=$(trace_matrix "$(echo "${fuc_matrix}" | rga "${header_el}")" | sed '1d')
		local row_num=$(echo "${base_static_info}" | rga "^${header_el}"$'\t' | awk '{print $2}')
		local min=$(echo "${base_static_info}" | rga "^${header_el}"$'\t' | awk '{print $3}')
		local max=$(echo "${base_static_info}" | rga "^${header_el}"$'\t' | awk '{print $4}')
		local sum=$(echo "${base_static_info}" | rga "^${header_el}"$'\t' | awk '{print $5}')
		local av=$(echo "${base_static_info}" | rga "^${header_el}"$'\t' | awk '{print $6}')
		#echo ${fuc_matrix} | head -n 5
		local base_static_line=$(echo "${tr_fuc_matrx}" | awk -v header_el="${header_el}" -v row_num="${row_num}" -v sum="${sum}" -v av="${av}" -v max="${max}" -v min="${min}" '
				BEGIN {
			        OFS="\t" #タブ区切りの出力を設定している
			        cl_num=1; vsum=0; fact_row_num=0
			    }
				{
					if($cl_num > 0) {
						vsum+=($cl_num - av) ^ 2;
						fact_row_num+=1
					}
				} 
				END {
					if(fact_row_num > 0){
						print header_el, fact_row_num, min, max, sum, sum/fact_row_num, sqrt(vsum/fact_row_num)
					}else{
						print header_el, fact_row_num, "-", "-", "-", "-", "-"
					}
				}'
			)
		local base_static_info_v=$(cat <(echo "${base_static_info_v}") <(echo "${base_static_line}") | sed '/^$/d')
	done
	lecho "---"
	lecho "base_static_info_v"
	lecho "${base_static_info_v}"
	# display static table
	for i in $(seq 1 ${extend_disp_range})
	do
		local header_el="${header_list[$((i - 1))]}"
		local tr_fuc_matrx=$(trace_matrix "$(echo "${fuc_matrix}" | rga "${header_el}")" | sed '1d')
		local row_num=$(echo "${base_static_info_v}" | rga "^${header_el}"$'\t' | awk '{print $2}')
		local min=$(echo "${base_static_info_v}" | rga "^${header_el}"$'\t' | awk '{print $3}')
		local max=$(echo "${base_static_info_v}" | rga "^${header_el}"$'\t' | awk '{print $4}')
		local sum=$(echo "${base_static_info_v}" | rga "^${header_el}"$'\t' | awk '{print $5}')
		local av=$(echo "${base_static_info_v}" | rga "^${header_el}"$'\t' | awk '{print $6}')
		local sdv=$(echo "${base_static_info_v}" | rga "^${header_el}"$'\t' | awk '{print $7}')
		local base_static_line=$(echo "${fuc_matrix}" | gawk -v header_el="${header_el}" -v row_num="${row_num}" -v av="${av}" -v sdv="${sdv}" -v max="${max}" -v min="${min}" '
				BEGIN {
			        OFS="\t" #タブ区切りの出力を設定している
			        if('${i}' == 1) print "-", "quants", "min_row", "max_row", "av(sum)", "sdv"
			    }
				END {
					if(row_num > 0) print header_el, row_num, min, max, int(av), int(sdv)
					else print header_el, 0, "-", "-", "-", "-"
				}'
			)
		local base_static_result=$(cat <(echo "${base_static_result}") <(echo "${base_static_line}"))
	done
	echo "# static($fuc_title)"
	echo "${base_static_result}" | sed '/^$/d'
}