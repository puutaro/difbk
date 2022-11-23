#!/bin/bash


place_discription_file(){
	local after_desc_contents="${1}"
	case "${after_desc_contents}" in "");;
	*)
		local time_prefix=$(\
			echo "${BUCKUP_DESC_FILE_PATH}" \
			| sed \
				-e 's/'${SED_BUCK_UP_DIR_PATH}'\///' \
				-e 's/\/'${BUCKUP_DESC_FILE_NAME}'//' \
				-e 's/\//\\\//g' \
		)
		echo "$(\
				echo ${after_desc_contents} \
					| sed '1s/^/'${time_prefix}':\ /' \
					| tr -d '\n' \
			)" > ${BUCKUP_DESC_FILE_PATH}
		;;
	esac
	if [ -e ${BUCKUP_DESC_TEMP_FILE_PATH} ];then 
		rm ${BUCKUP_DESC_TEMP_FILE_PATH}; 
	fi
}