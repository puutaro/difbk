#!/bin/bash

display_help(){

	echo ---
	echo "#### -b (buckup)"
	echo "cmd:  difbk  bk -b [parent dir full path of buckup dir]"
	echo "common option"

	echo ---
	echo "####  bk (buckup)"
	echo "cmd:  difbk bk ([description][-dn (no description)][-LN (no label)][-full (fullbackup)]"
	echo "func: buckup"

	echo ---
	echo "####  lrs "
	echo "cmd:  difbk lrs ([-e (every one)] [-d(|e|v) desc search]"
	echo "func: ls mergelist"

	echo ---
	echo "####  sch "
	echo "cmd:  difbk sch [search path word] (-c(num) (contents search)[-d(|e|v) desc search]) "
	echo "func: search path by word"

	echo ---
	echo "####  diff "
	echo "cmd:  difbk diff ([target mergelist number (reffrer lrs merge list num or target file)|merge list path|diff target file path] ([-d(|e|v) desc search])"
	echo "func: merge date diff from recnt and num date"

	echo ---
	echo "####  clean (validation merge list) "
	echo "cmd:  difbk clean -v "
	echo "func: validation merge list (only recunt)"

	echo ---
	echo "####  rs "
	echo "cmd:  difbk rs  [mergelist_path (reffrer lrs merge list)|cp or merge bkfile path] [restore terget path [full path or grep path]]"
	echo "func: restore"

	echo ---
	echo "####  clean (clean up) "
	echo "cmd:  difbk clean -dddd [base save regester date (reffrer lrs merge list num) ]"
	echo "func: cleanup past buckup"

	echo ---
	echo "####  mrg "
	echo "cmd:  difbk mrg  -alt [target_dir(-/~/*)]|[target_buckup_dir(-/~/*)] (-alt target_parent_dir)"
	echo "func: restore"

}

echo "$(display_help)" | less -R