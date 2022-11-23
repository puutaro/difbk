#!/bin/bash


echo_delete_list_in_validate_latest_mrg_ls(){
	local buck_up_data_list=$(
		LANG=C \
		fd -IH . "${day_depth_path_list_l[@]}" \
		| sed 's/^'${SED_TARGET_PAR_DIR_PATH}'//' \
		| sort \
		| uniq \
	) 
	join -v 2  \
		<(\
			echo "${buck_up_data_list}" \
			| sed \
				-e 's/'${DFBK_GGIP_EXETEND}'//' \
				-e 's/\ /'${DIFBK_BLANK_MARK}'/g' \
			| sort \
		) \
		<(\
			echo "${base_list_contents}" \
			| sed 's/\ /'${DIFBK_BLANK_MARK}'/g' \
			| sort\
		) \
	| sed 's/^/99999\t/g' \
	| sed 's/'${DIFBK_BLANK_MARK}'/\ /g'
}