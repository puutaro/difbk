#!/bin/bash


echo_second_para(){
	local difbk_argument="${1}"
	local second_para_source=$(\
		echo "${difbk_argument}" \
		| sed 's/[",]//g'\
	)
	echo "${second_para_source}"
}