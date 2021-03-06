#!/usr/bin/env bash

set -e

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "=== [INFO] " ${machine}

readlink=readlink
sed=sed

if [[ $machine == "Mac" ]]; then
    readlink=greadlink
    sed=gsed
fi

FILE_PATH=`$readlink -f $0`
WORK_DIR=`dirname ${FILE_PATH}`
echo "=== [INFO] WORK_DIR: $WORK_DIR"

INSTANCE="test"
CMD=start


if [[ $# == 2 ]]; then
    CMD=$1
    INSTANCE=$2
else
    echo "usage: $0 start|stop instance_name"
    exit
fi

echo "=== [INFO] check instance: $INSTANCE"
if [[ ! -d $INSTANCE ]]; then
    echo "=== [ERROR] instance $INSTANCE not exist"
    exit
fi

if [[ $CMD == "start" ]]; then
    mysqld_safe --defaults-file=$WORK_DIR/$INSTANCE/my.cnf >/dev/null 2>&1 &
elif [[ $CMD == "stop" ]]; then
    mysqladmin shutdown -S $WORK_DIR/$INSTANCE/mysql.sock -uroot -p123456
fi

echo "=== [INFO] enjoy!!!"
