#!/bin/bash


reset_confirm(){
	local delete_recent_datetime_bkdir="${1}"
	read -ep "ok?(y), delete_recent_datetime_bkdir ${delete_recent_datetime_bkdir} :> " \
		confirm
	case "${confirm}" in
		"y") break ;;
		*) exit 0 ;;
	esac
}
