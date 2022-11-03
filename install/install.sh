#!/bin/bash
CURRENT_DIR_PATH="$(echo $(cd $(dirname $0) && pwd))"
key_input_os_type="${1}"
declare -A OS_TYPE_MAPS=(	
	["l"]="linux"
	["m"]="mac"
	["w"]="win"
)
execute_installer(){ bash "${CURRENT_DIR_PATH}/${1}/installer.sh" ;}
case "${key_input_os_type}" in 
	"")
		while true	
		do
			echo -e "${OS_TYPE_MAPS["l"]}\n${OS_TYPE_MAPS["m"]}\n${OS_TYPE_MAPS["w"]}"
			read -ep "type your os type in above :> " input_os_type 
			case "${input_os_type}" in 
				"${OS_TYPE_MAPS["l"]}"|"${OS_TYPE_MAPS["m"]}"|"${OS_TYPE_MAPS["w"]}") break ;;
				*) ;; esac
		done ;;
	*)
		input_os_type="${OS_TYPE_MAPS[${key_input_os_type}]}"

;; esac 
execute_installer "${input_os_type}"
	