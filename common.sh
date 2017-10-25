#!/bin/bash
#===============================================================================
#
#         FILE:  common.sh
#
#  DESCRIPTION:  Bash脚本的公用函数
#                使用:
#                if [ ! -r "脚本根目录/lib/common.sh" ]
#                then
#                   echo "Can not find common file @ 脚本根目录/lib"
#                   exit 99
#                fi
#                source "`脚本根目录/lib/common.sh"
#                if [ "$?" != 0 ]
#                then
#                echo "Source 脚本根目录/lib/common.sh failed"
#                exit 99
#                fi
#                编写函数时候注意，函数名称下的##行为命令行解释行，一定需要定义
#                common.sh -h 可以打印所有可用的函数
#
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  x2x4@x2x4.net
#      COMPANY:
#      VERSION:  1.0
#      CREATED:  2013/03/06 10时48分15秒
#     REVISION:  ---
#===============================================================================

check_return() {
  ## check command return , $1为之前执行状态码，$2为命令
  ## Example:
  ##   echo "hello world"
  ##   check_return $? "echo \"hello world\""
  status=$1
  command=$2
  if [ "$status" != 0 ]
  then
    error 99 "[ $command ] run failed"
  fi
}

check_type() {
  ## check file or dir type,
  ## $1 is type $2 is file or dir; same as if [ -d "xxx" ], here d is $1; "xxx" is $2
  ## Example:
  ##   check_type w "/tmp/logfile.log"
  case $1 in
    w | write)
      if [ ! -w "$2" ]
      then
        log "Can not write $2"
        exit 99
       fi
    ;;
    r | read)
      if [ ! -r "$2" ]
      then
        log "Can not read $2"
        exit 99
      fi
    ;;
    d | dir)
      if [ ! -d "$2" ]
      then
        log "$2 is not dir"
        exit 99
      fi
    ;;
    f | file)
      if [ ! -f "$2" ]
      then
        log "$2 is not file"
        exit 99
      fi
    ;;
    x | exec)
      if [ ! -e "$2" ]
      then
        log "$2 can not run"
        exit 99
      fi
    ;;
    *)
      log "check_type miss parms"
      exit 99
  esac
}

log() {
  ## if defined $log_file store msg to log_file or stdout msg
  ## DEBUG=1 to show everything on STDOUT
  ## Example:
  ##   log "Hello world"
  msg=$1
  local log_dir=`dirname $log_file`
  if [ -w "$log_file" ] || [ -w "$log_dir" ]
  then
    echo -n `date "+[%Y-%m-%d %H:%M:%S]"` >> $log_file
    echo " $msg" >> $log_file
  fi
  if [ -n "$DEBUG" ] && [ $DEBUG -eq 1 ]
  then
    echo -n `date "+[%Y-%m-%d %H:%M:%S]"`
    echo " $msg"
  fi
}

error() {
    ## output error msg and exit with exit_code
    ## Example:
    ## error 127 "Can not file file"
    exit_code=$1
    err_msg=$2
    local log_dir=`dirname $log_file`
    if [ -w "$log_file" ] || [ -w "$log_dir" ]
    then
      echo -n `date "+[%Y-%m-%d %H:%M:%S]"` >> $log_file
      echo " $msg" >> $log_file
    fi
    echo -n `date "+[%Y-%m-%d %H:%M:%S]"`
    echo " [!!ERROR!!] $err_msg"
    exit $exit_code
}

check_parms() {
  ## check parm
  ## $1 is name $2 is vars
  ## Example:
  ##   check_parms log_file $log_file
  if [ -z "$2" ]
  then
    log "$1 is empty, please check"
    exit 99
  fi
}

echo_success() {
    ## echo with color
    ## $1 word to echo
    ## Example:
    ##   echo_success "ok"
    word=$1
    echo -e "\033[32m${word}\e[m"
}

echo_failed() {
    ## echo with color
    ## $1 word to echo
    ## Example:
    ##   echo_failed "failed"
    word=$1
    echo -e "\033[31m${word}\e[m"
}

echo_warning() {
    ## echo with color
    ## $1 word to echo
    ## Example:
    ##   echo_warning "warning"
    word=$1
    echo -e "\033[33m${word}\e[m"
}


list_comm() {
  ## list all comm subs
  #`grep -E '^\w+\(\)' $0 | cut -d '(' -f 1`
  bin_file=$1
  echo "List available subs"
  grep -E '^(\w+\(\)|\s*##)' $bin_file | cut -d '(' -f 1
}

if [ -n "$1" ] && [ "$1" == "-h" ]
then
    list_comm $0
fi
