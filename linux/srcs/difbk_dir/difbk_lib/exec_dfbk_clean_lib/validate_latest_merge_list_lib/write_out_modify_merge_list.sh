#!/bin/bash


write_out_modify_merge_list(){
	local latest_merge_file_list_path="${1}"
	local delete_list_mark="DLDLDLDLDLDLDL"
	modify_merge_list=$(\
		cat \
			<(\
				echo "${delete_list}" \
				| sed \
					-r "s/^([0-9d]{1,20})\t/${delete_list_mark}\t/"\
			) \
			<(\
				echo "${base_list_contents_source}"\
			) \
		| sort -k 2,2 \
		| uniq -u -f 1 \
		| rga -v "^${delete_list_mark}\t"\
	)
	echo "${modify_merge_list}" \
		| gzip -c \
		> "${latest_merge_file_list_path}"
}