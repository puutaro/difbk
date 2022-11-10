#!/bin/bash


echo_clean_file_list_con(){
	join -v 1 \
		<(\
			echo "${delete_buckup_file_type_list_con}" \
			| sed 's/'${SED_DFBK_GGIP_EXETEND}'//g' \
			| sed 's/\ /'${DIFBK_BLANK_MARK}'/g' \
			| sort \
		) \
		<(\
			echo "${delete_supper_merge_list_contents}" \
			| sed 's/\ /'${DIFBK_BLANK_MARK}'/g' \
			| sort\
		)  \
	| sed 's/'${DIFBK_BLANK_MARK}'/\ /g'
}