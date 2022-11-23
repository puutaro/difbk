#!/bin/bash


echo_delete_buckup_file_type_list_con(){
	local delete_buckup_dir_list_con=$(\
		fd -t d -IH \
			. "${day_depth_path_lists[@]}" \
		| sed 's/^'${SED_TARGET_PAR_DIR_PATH}'//' \
		| sort \
		| uniq \
	)

	local delete_buckup_all_list_con=$(\
		fd -IH . "${day_depth_path_lists[@]}" \
		| sed 's/^'${SED_TARGET_PAR_DIR_PATH}'//' \
		| sort \
		| uniq \
	) 
	join -v 1  \
		<(\
			echo "${delete_buckup_all_list_con}" \
			| sed \
				-e 's/\ /'${DIFBK_BLANK_MARK}'/g' \
			| sort \
		) \
		<(\
			echo "${delete_buckup_dir_list_con}" \
			| sed 's/\ /'${DIFBK_BLANK_MARK}'/g' \
			| sort\
		) \
	| sed 's/'${DIFBK_BLANK_MARK}'/\ /g'
}