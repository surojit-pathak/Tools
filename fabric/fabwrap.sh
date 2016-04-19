#!/bin/bash

FSELF=`readlink -e "${BASH_SOURCE[0]}"`
FABFILE=`dirname $FSELF`/fabfile.py
#FABEX="fab --skip-bad-hosts"
FABEX="fab -A"
FAB=$FABEX" -f "$FABFILE

### XXX: Caution fabric resets shells params like stdin
function fabwrap_node_run_cmd ()
{
    if [ $# -lt 2 ]
    then
        printf "Usage: $0 <command> <Node_file_name | node_file_path_regex>\n"
        return 1
    fi

    cmd="$1"
    shift

    for file in "$@"
    do
        for i in `cat $file`
        do
            $FAB -H $i node_run_cmd:cmd="$cmd"
        done
    done
}

### XXX: Caution fabric resets shells params like stdin
function fabwrap_node_run_sudo_cmd ()
{
    if [ $# -lt 2 ]
    then
        printf "Usage: $0 <command> <Node_file_name | node_file_path_regex>\n"
        return 1
    fi

    cmd="$1"
    shift

    sudo_pw=`cat $DEFAULT_SUDO_PWD_FILE`

    for file in "$@"
    do
        for i in `cat $file`
        do
            $FAB -H $i node_run_sudo_cmd:cmd="$cmd",sudo_pw=$sudo_pw
        done
    done
}

function fabwrap_run_cmds_for_host ()
{
    if [ $# -ne 2 ]
    then
        printf "Usage: $0 <host> <command_file>\n"
        return 1
    fi

    local host=$1
    local file=$2

    ping -q -c 2 $host > /dev/null
    if [ $? -ne 0 ] ; then printf "Invalid hostname/IP %s\n" $host; return 1; fi

    if [ ! -f $file ] ; then printf "Invalid command file  %s\n" $file; return 1; fi

    local cmdNum=`cat $file | wc -l`

    local counter=1
    while [ $counter -le $cmdNum ]
    do
        local line=`sed -n "${counter}p" < $file`
        $FAB -H $host node_run_cmd:cmd="$line"
        counter=`expr $counter + 1`
    done
}

