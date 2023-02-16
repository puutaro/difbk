#!/bin/bash

display_help(){

	echo ---
	echo "#### -b (buckup)"
	echo "common option"
	echo "cmd:  difbk  bk -b [parent dir full path of buckup dir]"

	echo ---
	echo "####  bk (buckup)"
	echo "feature: buckup"
	echo "cmd:  difbk bk ([description][-dn (no description)][-ln (no label)][-full (fullbackup)]"
	echo -e "\t\t[-mklabel {word}: make a label at the beginning of the description"
	echo -e "\t\t[-rmlabel {word}: remove a label at the beginning of the description"
	echo -e "\t\t[-lslabel {word}: list the registerd labels\n"

	echo ---
	echo "####  rbk (restore buckup to current project directory)"
	echo "feature: restore backup"
	echo "cmd:  difbk rbk [merge list path or order num (number in left brackets when type difkb lrs -e )]"

	echo ---
	echo "####  reset"
	echo "feature: remove recent buckup"
	echo -e "cmd:  difbk reset ([-s (no confirm)]\n"

	echo ---
	echo "####  st (status)"
	echo "feature: change files"
	echo -e "cmd:  difbk st (target mergelist number (reffrer lrs merge list num or target file)|merge list path) \n"

	echo ---
	echo "####  sd (status diff)"
	echo "feature: merge list diff from current directory"
	echo -e "cmd:  difbk sd (target mergelist number (reffrer lrs merge list num or target file)|merge list path) \n"

	echo ---
	echo "####  lrs "
	echo "feature: ls merge_list"
	echo "cmd:  difbk lrs ([-e: every one] [-d {word}: desc search for {word}(And search with multiple specifications )] [-full: full merge list display]"
	echo -e "\t\t[-d {word}: desc search for {word}(And search with multiple specifications )]"
	echo -e "\t\t[-dv {word}: desc exclude search (And search with multiple specifications )"
	echo -e "\t\t[-de {word}: desc or search (Or search with multiple specifications, cannot be combined with normal desc search)"
	echo -e "\t\t[-db {YYYY/MM/DD/hhmm}: delete before datetime in description (leaves future)"
	echo -e "\t\t[-da {YYYY/MM/DD/hhmm}: delete after datetime in description (leaves past)\n"

	echo ---
	echo "####  sch "
	echo "feature: search path by word"
	echo "cmd:  difbk sch [search path word] (-c(num) (contents search)[-d(|e|v) desc search]) "
	echo -e "\t\t[-d {word}: desc search for {word}(And search with multiple specifications )]"
	echo -e "\t\t[-dv {word}: desc exclude search (And search with multiple specifications )"
	echo -e "\t\t[-de {word}: desc or search (Or search with multiple specifications, cannot be combined with normal desc search)"
	echo -e "\t\t[-db {YYYY/MM/DD/hhmm}: delete before datetime in description (leaves future)"
	echo -e "\t\t[-da {YYYY/MM/DD/hhmm}: delete after datetime in description (leaves past)"
	echo -e "\t\t[-j {merge_list_file_path|merge_list_order(when 'difbk lrs -e' display in left brackets)}; merge_list search"
	echo -e "\t\t[- {merge_list_file_path|merge_list_order(when 'difbk lrs -e' display in left brackets)}\n"

	echo ---
	echo "####  diff "
	echo "feature: merge date diff from recent and num date"
	echo "cmd:  difbk diff ([blank(current dir diff) | target mergelist number (reffrer lrs merge list num or target file)|merge list path|diff target file path] ([-d(|e|v) desc search])"
	echo -e "\t\t[-d {word}: desc search for {word}(And search with multiple specifications )]"
	echo -e "\t\t[-dv {word}: desc exclude search (And search with multiple specifications )"
	echo -e "\t\t[-de {word}: desc or search (Or search with multiple specifications, cannot be combined with normal desc search)"
	echo -e "\t\t[-db {YYYY/MM/DD/hhmm}: delete before datetime in description (leaves future)"
	echo -e "\t\t[-da {YYYY/MM/DD/hhmm}: delete after datetime in description (leaves past)\n"

	echo ---
	echo "####  clean (validation merge list) "
	echo "feature: validation merge list (only recunt)"
	echo -e "cmd:  difbk clean -v \n"

	echo ---
	echo "####  rs "
	echo "feature: restore"
	echo "cmd:  difbk rs  [mergelist_path (reffrer lrs merge list)|cp or merge bkfile path] [restore terget path] (grep path(sart target dirname right under path)) from merge_list]"
	echo -e "\t\t[-c: copy buckup file to restore terget path]\n"

	echo ---
	echo "####  clean (clean up) "
	echo "feature: cleanup past buckup"
	echo -e "cmd:  difbk clean -dddd [base save regester date (reffrer lrs merge list num) ]\n"

	echo ---
	echo "####  mrg "
	echo "feature: restore"
	echo "cmd:  difbk mrg  -alt [target_dir(-/_/{word})] [target_buckup_dir(-/_/{word})] (-:curent\dir_name, -: blank(delete))"
	echo -e "\t\t[-dest destination dirctory full path: mrg contents move destination)\n"

}

echo "$(display_help)" | less -R