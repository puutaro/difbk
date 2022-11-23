#!/bin/bash


wait_spin(){
	local target_pid="${1}"
	local wait_message="${2}"
	local spin[0]="-"
	local spin[1]="\\"
	local spin[2]="|"
	local spin[3]="/"

	local spin='-\|/'
	local i=0
	local string_num=$(("${#wait_message}" + 2))
	while kill -0 "${target_pid}" 2>/dev/null
	do
	  i=$(( (i+1) %4 ))
	  printf "\r ${wait_message} ${spin:$i:1} "
	  sleep .1
	done
	printf "\r ${wait_message} ok "
	echo ""
}