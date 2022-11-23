#!/bin/bash


remove_when_exist_restore_target_dir(){
	local restore_target_dir_path="${1}"
	while [ true ]
	do
		local rs_target_insert_dir_path=$(\
			echo "${restore_target_dir_path}/${TARGET_DIR_NAME}" \
			| sed \
				-e 's/\/\//\//g' \
				-e 's/\/$//'\
		)
		if [ ! -d "${rs_target_insert_dir_path}" ];then break;fi
		echo "delete directory ok?(y/n): ${rs_target_insert_dir_path}"
		read -e confirm
		if [ "${confirm}" != "y" ];then exit 0 ;fi
		cd ../
		rm -rf "${rs_target_insert_dir_path}" 
		[ ! -e "${DFBK_SETTING_DIR_PATH}" ] \
			&& mkdir -p "${DFBK_SETTING_DIR_PATH}"
		cd "${TARGET_DIR_PATH}"
		break;
	done
}