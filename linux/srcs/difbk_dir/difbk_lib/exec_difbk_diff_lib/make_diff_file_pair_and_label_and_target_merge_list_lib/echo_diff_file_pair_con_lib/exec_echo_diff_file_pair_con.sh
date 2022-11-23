#!/bin/bash


exec_echo_diff_file_pair_con(){
	cat \
		<(\
			echo "${LS_CREATE_BUCKUP_MERGE_CONTENTS}" \
			| rga \
				-v "${CHECH_SUM_DIR_INFO}" \
			| cut -f2 \
			| sed -r "s/^(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})(.*)/\1\t\2/"\
		) \
		<(\
			echo "${LS_DELETE_BUCKUP_MERGE_CONTENTS}" \
			| rga \
				-v "${CHECH_SUM_DIR_INFO}" \
			| cut -f2 \
			| sed \
				-r "s/^(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})(.*)/\1\t\2/"\
		)  \
		| sed 's/$/'${DFBK_GGIP_EXETEND}'/' \
		| sed "s/\.gz${SED_DFBK_GGIP_EXETEND}/\.gz/" \
		| sort -k 2,2 \
		| uniq -f 1 -D \
		| sed -r "s/^(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})\t(.*)/\"..\1\2\"/"
}