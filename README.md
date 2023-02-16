
# `difbk`
Command line differential backup tool made by 100% shell script.

![image](https://user-images.githubusercontent.com/55217593/201099244-36ea4227-ef06-4290-9a65-edf3ee025874.png)

It's a differential backup tool, which have ritch feature: backup, fullbackup, search, grep, diff, restore, clean up.

Pros
----
- Ritch feature
- use filesystem itself (when you want to complement the function, you can use shell command very easily, you can easily transfer data to other pc or file system)
- Since it is compressed and save, saves data (gzip type)
- It form golden combination with git (when your project is too security sensitive to use git, file transfer other branch, and you have half-finished but important edits)

Table of Contents
-----------------
<!-- vim-markdown-toc GFM -->

* [Installation](#installation)
  * [For Ubuntu or Debian or Wsl](#for-ubuntu-or-debian-or-wsl)
* [Upgrading](#upgrading)
  * [Upgrading for Ubuntu or Debian or Wsl](#upgrading-for-ubuntu-or-debian-orwsl)
* [Demo](#demo)
* [Usage](#usage)
  * [Buckup](#buckup)
  * [Status](#status)
  * [Reset](#reset)
  * [List backup files](#list-backup-files)
  * [Search](#search)
  	* [Path search](#path-search)
  	* [contents search](#contents-search)
  * [Status diff](#status-diff)
  * [Diff](#diff)
  * [Restore](#restore)
	* [All buckup files restore](#all-buckup-files-restore)
    * [One buckup file restore](#one-buckup-file-restore)
  * [Clean](#install)
     * [Validate backup list file](#validate-backup-list-file)
     * [Delete specify backup generation](#delete-specify-backup-generation)
  * [Merge](#merge)

Installation
-----

### For Ubuntu or Debian or Wsl

- Support Ubuntu20.04+

```
git clone https://github.com/kitamura-take/difbk.git ~/.difbk
cd ~/.difbk/install
bash install.sh l
```


Upgrading.
-----


### Upgrading for Ubuntu or Debian
1. delete $HOME/.difbk directory
2. same as installation.

Usage
-----

### Buckup

It mean diffrencial backup

1. type bellow command

```
difbk bk -d "{backup description}"
```

2. If `label stamp` exist, select and type esc

![image](https://user-images.githubusercontent.com/55217593/201099244-36ea4227-ef06-4290-9a65-edf3ee025874.png)

- back up option

    | option| set value | comment  |
    | --------- | --------- | ------------ |
    | `-d` | string | backup'e description  |
    | `-dn`  | no | no set backup'e description |
    | `-mklabel`  | string | label stamp attached to the beginning of the description (ex label -> [label] ~ ) |
    | `rmlabel` | string | remove registerd label  |
    | `lslabel` | no | list registerd labels  |
    | `-ln`  | no | when backup, not add label stamp |


### Status

It mean confirm status

1. type bellow command

```
difbk st (target mergelist number (reffrer lrs merge list num or target file)|merge list path)
```

![image](https://user-images.githubusercontent.com/55217593/203556258-fa2c36bf-6679-43d5-8d12-046ac8e24efe.png)



### Reset
remove recent backup  
1. type bellow command

```
difbk reset  
```

- lrs option

    | option| set value | comment  |
    | --------- | --------- | ------------ |
    | `-s` | no | without comfirm, remove it |

### List backup files
`difbk` management backup generation by backup files's text file(in fact commpressed into gz). Here list backup's list text files. this subcommand is base command in `difbk`. This is used for `sch`, `rs` and `diff`, etc. When add no `-full`  option, display recent 30 merge file path  

1. type bellow command

```
difbk lrs -e
```

![image](https://user-images.githubusercontent.com/55217593/201107634-1a83d424-94be-4be0-8219-42f628e963b0.png)

- lrs option

    | option| set value | comment  |
    | --------- | --------- | ------------ |
    | `-e` | no | display every backup file |
    | `-d`  | string | description's `include` filter string |
    | `-de`  | string | description's `or` filter string |
    | `-dv` | string | description's `exclude` filter label  |
    | `-full` | no | full merge list display |

### Search

`difbk` can search path or file contents. It's freqently use feature, and strong one at the same time.

#### Path search
1. type bellow command

```
difbk sch {search path word1} {search path word2} {search path word3} ...
```

- It's `and` search.

![image](https://user-images.githubusercontent.com/55217593/201111004-a6ab02d2-d142-4e5d-aefb-23f0cf857ffd.png)

- sch option

    | option| set value | comment  |
    | --------- | --------- | ------------ |
    | `-e` | string | `or` search |
    | `-v` | string | `exclude` search |
    | `-d`  | string | description's `include` filter string |
    | `-de`  | string | description's `or` filter string |
    | `-dv` | string | description's `exclude` filter label  |
    | `-da` | datetime string (YYYY/MM/DD/hhmm) | delete after datetme |
    | `-db` | datetime string (YYYY/MM/DD/hhmm) | delete before datetme |
    | `-j` | int | generation number (when `difbk lrs -e`, display in left brackets) |

#### Contents search
1. type bellow command

```
difbk sch -c {search path word}
```

![image](https://user-images.githubusercontent.com/55217593/201113737-0e11eca7-a747-41b3-ae7c-7fdf1fc19f15.png)

- sch -c option

    | option| set value | comment  |
    | --------- | --------- | ------------ |
    | `-d`  | string | description's `include` filter string |
    | `-de`  | string | description's `or` filter string |
    | `-dv` | string | description's `exclude` filter label  |
    | `-da` | datetime string (YYYY/MM/DD/hhmm) | delete after datetme |
    | `-db` | datetime string (YYYY/MM/DD/hhmm) | delete before datetme |
    | `-j` | int | every generation number (when `difbk lrs -e`, display in left brackets) |


### Status diff

1. type bellow command

```
difbk diff (target mergelist number (reffrer lrs merge list num or target file)|merge list path)
```


### Diff

1. type bellow command

```
difbk diff { blank (current direcotry diff) | generation number or backup list file path or backuped file path}
```

![image](https://user-images.githubusercontent.com/55217593/201114773-be3d04b6-c8e1-4fd5-8f77-cbe7b1b13564.png)

- diff option

    | option| set value | comment  |
    | --------- | --------- | ------------ |
    | `-e`  | int | every generation search on (default daily diff) |
    | `-de`  | string | description's `or` filter string |
    | `-dv` | string | description's `exclude` filter label  |
    | `-da` | datetime string (YYYY/MM/DD/hhmm) | delete after datetme |
    | `-db` | datetime string (YYYY/MM/DD/hhmm) | delete before datetme |




### Restore

#### All buckup files restore

This is generally called restore

1. type bellow command

```
difbk rs {backup list file path} {destination directory} (grep path from backup list)
```

#### One buckup file restore
This restore only one buckup file. In a nutshell, `merge` or `copy`

1. type bellow command

```
difbk rs {backup one file path}
```

- above command mean `merge`

- merge option

    | option| set value | comment  |
    | --------- | --------- | ------------ |
    | `-c`  | no | not `merge` but `copy` |


#### Restore buckup to current project directory

1. type bellow command

```
difbk rbk [merge list path or order num (number in left brackets when type difkb lrs -e )]
```

### Clean

#### Validate backup list file
`difbk` mainly use backup list file. Threfore, this have sub command that varidate backup list file.


1. type bellow command

```
difbk clean -vl
```
- latest backup file check and if finding miss, correct.

#### Delete specify backup generation
Although `difbk` compress file and save one, Data can be bloated with long use. when so , delete spedify generation, and litghten the buckup.


1. type bellow command

```
difbk clean -dddd {generation number you wont to leaves last}
```
- `generation number` is larger three.


### Merge
When you want to merge backups and you want to rename project directory, `difbk` can do.

1. type bellow command

```
difbk mrg -alt {project directory after renamd} {backup root directory after renamed}
```
- `backup root project directory` mean `old_{project directory name}`　in the same hierarchy as the project directory

- `{project directory after renamd}` can use `-` for current project directory name and `_` for deleting current project directory name
- `{backup root directory after renamed}` can use `-` for current backup root project directory name and `_` for deleting current backup root project directory name

- merge option
	| option| set value | comment  |
    | --------- | --------- | ------------ |
    | `-dest` | string | destination directory full path for move|
