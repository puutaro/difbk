#!/bin/bash

copy_exec(){
	local sed_buck_up_create_dir_path=$(echo "${BACKUP_CREATE_DIR_PATH}" | sed 's/\//\\\//g')
	local input_copy_contents="${1}"
	local mkdir_shell_path="${DFBK_SETTING_DIR_PATH}/copy_mkdir.sh"
	local get_dir_name_shell_path="${DFBK_SETTING_DIR_PATH}/get_dir_name.sh"
	case "${2}" in 
		"-u")
			echo "${input_copy_contents}" | rga "${CHECH_SUM_DIR_INFO}" | cut -f2 | sed -e 's/^\/'${BUCK_UP_DIR_NAME}'\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/'${BACKUP_CREATE_DIR_NAME}'\///' -e 's/^/'${sed_buck_up_create_dir_path}'\//' -e 's/\/\//\//' -e '/^$/d' -e "s/^/mkdir -p \"/" -e "s/$/\" \&/"  -e "1000~2000 i wait" -e '$ a wait'  > "${mkdir_shell_path}"
			;;
		*)
			local input_copy_make=$(echo "${input_copy_contents}" | sed -e 's/\t\/'${BUCK_UP_DIR_NAME}'\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/'${BACKUP_CREATE_DIR_NAME}'\//\t/' -e 's/\t/\t'${sed_buck_up_create_dir_path}'/' -e 's/\/\//\//' -e '/^$/d')
			# echo "input_copy_make: $(echo  "${input_copy_make}" | head -n  "${DISPLAY_LIMIT}")"
			local mkdir_shell_con=$(echo "${input_copy_make}" | rga "${CHECH_SUM_DIR_INFO}" | cut -f2 | sed -e "s/^/mkdir -p \"/" -e "s/$/\" \&/")
			case "${edit_desk_code}" in 
				"-full") ;;
				*)
					echo "${input_copy_make}" | rga -v "${CHECH_SUM_DIR_INFO}" | cut -f2 | sed -e "s/^/dirname \"/" -e "s/$/\" \&/" > "${get_dir_name_shell_path}"
					local dir_name_con=$(bash "${get_dir_name_shell_path}" | sort | uniq)
					mkdir_shell_con=$(cat <(echo "${dir_name_con}" | sed -e '/^$/d' -e "s/^/mkdir -p \"/" -e "s/$/\" \&/") <(echo  "${mkdir_shell_con}") | sed '/^$/d' | sort | uniq)
				;;
			esac
			echo "${mkdir_shell_con}"  | sed -e "1000~2000 i wait" -e '$ a wait'  > ${mkdir_shell_path}
			;;
	esac
	# echo "mkdir_shell_path: $(cat  "${mkdir_shell_path}" | head -n "${DISPLAY_LIMIT}")"
	bash "${mkdir_shell_path}"
	wait
	local file_cp_shell_path="${DFBK_SETTING_DIR_PATH}/copy_file.sh"
	case "${2}" in 
		"-u")
			local cp_row_con=$(echo "${input_copy_contents}" | rga -v "${CHECH_SUM_DIR_INFO}" | cut -f2)
			echo "${cp_row_con}" | rga -v "\.gz$" | rga -v "@$" | sed -re "s/(.*)/\"${SED_TARGET_PAR_DIR_PATH}\1\"\t\"\1\"/" | sed -e "s/\t\"\/${BUCK_UP_DIR_NAME}\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/${BACKUP_CREATE_DIR_NAME}\//\t\"/" -e "s/\t\"/\t\"${sed_buck_up_create_dir_path}\//" | sed 's/\/\//\//' | sed -r "s/(\"[^\"]*\")\t(\"[^\"]*\")/cp -arvf \1${DFBK_GGIP_EXETEND} \2${GGIP_EXETEND} \&\& gunzip\t\2${GGIP_EXETEND} || cp -arvf \1 \2 || e=\$\? \&/" | sed -e 's/\t/\ /g' -e '/^$/d' -e "1000~2000 i wait" -e '$ a wait' > "${file_cp_shell_path}"
			echo "${cp_row_con}" | rga "\.gz$" | rga -v "@$" | sed -re "s/(.*)/\"${SED_TARGET_PAR_DIR_PATH}\1\"\t\"\1\"/" | sed -e "s/\t\"\/${BUCK_UP_DIR_NAME}\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/${BACKUP_CREATE_DIR_NAME}\//\t\"/" -e "s/\t\"/\t\"${sed_buck_up_create_dir_path}\//" -e 's/\/\//\//' -re "s/(\"[^\"]*\")\t(\"[^\"]*\")/cp -arvf \1 \2 || e=\$\? \&/" | sed -e 's/\t/\ /g' -e '/^$/d'  -e "1000~2000 i wait" -e '$ a wait' >> "${file_cp_shell_path}"
			echo "${cp_row_con}" | rga -v "\.gz$" | rga "@$" | sed -re "s/(.*)/\"${SED_TARGET_PAR_DIR_PATH}\1\"\t\"\1\"/" | sed -e "s/\t\"\/${BUCK_UP_DIR_NAME}\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/${BACKUP_CREATE_DIR_NAME}\//\t\"/" -e "s/\t\"/\t\"${sed_buck_up_create_dir_path}\//" -e 's/\/\//\//' -re "s/(\"[^\"]*\")\t(\"[^\"]*\")/cp -arvf \1 \2 || e=\$\? \&/" | sed -e 's/\t/\ /g' -e '/^$/d'  -e "1000~2000 i wait" -e '$ a wait' >> "${file_cp_shell_path}"
			;;
		*)
			echo "${input_copy_contents}" | rga -v "${CHECH_SUM_DIR_INFO}" | cut -f2 | sed -re "s/(.*)/cp -arvf \"${SED_TARGET_PAR_DIR_PATH}\1\"\t\"\1\"/" -e "s/\t\"\/${BUCK_UP_DIR_NAME}\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/${BACKUP_CREATE_DIR_NAME}\//\t\"/" -e "s/\t\"/\t\"${sed_buck_up_create_dir_path}\//" -e 's/\/\//\//' -re "s/\t(\".*\")/\t\1 \&\& gzip\t\1 \&\& mv\t\1${GGIP_EXETEND}\t\1${DFBK_GGIP_EXETEND} || e=\$\? \&/" -e 's/\t/\ /g' -e '/^$/d' -e "1000~2000 i wait" -e '$ a wait' > "${file_cp_shell_path}"
			;;
	esac
	bash "${file_cp_shell_path}"
}
