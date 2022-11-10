#!/bin/bash


end_when_recent_merge_list_path(){
	local recent_merge_list_path="${1}"
	case "${recent_merge_list_path}" in
		"") 
			echo "please command: difbk bk ( no exist merge list"
			exit 0
	;; esac
}