#!/bin/bash


wait_spin(){
	local target_pid="${1}"
	local wait_message="${2}"
	local spin='-\|/'
	local i=0
	while kill -0 "${target_pid}" 2>/dev/null
	do
	  i=$(( (i+1) %4 ))
	  printf "\r ${wait_message} ${spin:$i:1} "
	  sleep .1
	done
	printf "\r ${wait_message} ok "
	echo ""
}