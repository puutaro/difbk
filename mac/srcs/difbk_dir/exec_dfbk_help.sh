#!/bin/bash

display_help(){
	echo ---
	echo "####  bk (buckup)"
	echo "cmd:  difbk bk ([-full (fullbackup)][-d (description)]"
	echo "func: buckup"

	echo ---
	echo "####  lrs "
	echo "cmd:  difbk lrs ([-d (every day or -e (every one)] [display limit (num)] [randome_rate (num)]]"
	echo "func: ls mergelist"

	echo ---
	echo "####  sch "
	echo "cmd:  difbk sch [search path word] (-c (contents search))"
	echo "func: search path by word"

	echo ---
	echo "####  diff "
	echo "cmd:  difbk diff ([target mergelist number (reffrer lrs merge list num or target file)]"
	echo "func: merge date diff from recnt and num date"

	echo ---
	echo "####  als "
	echo "cmd:  difbk als  [apeal register date range (num)] [display limit (num, 5 over detail mode(full analysis))]]"
	echo "func: analitics history"

	echo ---
	echo "####  clean (validation merge list) "
	echo "cmd:  difbk clean -v "
	echo "func: validation merge list (only recunt)"

	echo ---
	echo "####  rs "
	echo "cmd:  difbk rs  [mergelist_path (reffrer lrs merge list)] [restore terget path [full path or grep path]]"
	echo "func: restore"

	echo ---
	echo "####  clean (clean up) "
	echo "cmd:  difbk clean -dddd [base save regester date (reffrer lrs merge list num) ]"
	echo "func: cleanup past buckup"
}

echo "$(display_help)" | less -R