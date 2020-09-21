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

MYSQLD="mysql-5.7.30"
INSTANCE="test"
PORT=3306
MODE=RELEASE


if [[ $# == 2 ]]; then
    INSTANCE=$1
    PORT=$2
elif [[ $# == 3 ]]; then
    MYSQLD=$1
    INSTANCE=$2
    PORT=$3
elif [[ $# == 4 ]]; then
    MYSQLD=$1
    MODE=$2
    INSTANCE=$3
    PORT=$4
else
    echo "usage: $0 [mysqld_dir, e.g. mysql-5.7.30] [debug/release, default is release] instance_name port"
    exit
fi

echo "=== [INFO] check mysqld_dir: $MYSQLD"
if [[ ! -d mysqld/$MYSQLD ]]; then
    echo "=== [ERROR] dir mysqld/$MYSQLD not exist"
    exit
fi
if [[ ! -f mysqld/$MYSQLD/bin/mysqld ]]; then
    echo "=== [ERROR] file mysqld mysqld/$MYSQLD/bin/mysqld not exist"
    exit
fi
echo "=== [INFO]] mysql version: " `mysqld/$MYSQLD/bin/mysqld --version`


echo "=== [INFO] check instance name: $INSTANCE"
if [[ -d $INSTANCE ]]; then
    echo "=== [ERROR] dir $INSTANCE exist"
    exit
fi

echo "=== [INFO] check port: $PORT"
pIDa=`/usr/sbin/lsof -i :$PORT|grep -v "PID" | awk '{print $PORT}'`
if [ "$pIDa" != "" ]; then
   echo "=== [ERROR] port $PORT used by $pIDa"
   exit
fi


echo "=== [INFO] deploy $MYSQLD $MODE in [$INSTANCE], listen on $PORT"

echo "=== [INFO] cp data to $INSTANCE"
cp -r demo $INSTANCE
cp my.cnf.temp $INSTANCE/my.cnf

echo "=== [INFO] modify my.cnf"
BASE_DIR=`echo $WORK_DIR|sed 's/\//\\\\\//g'`
$sed -i "s/#base_dir#/$BASE_DIR/g" $INSTANCE/my.cnf
$sed -i "s/#mysqld#/$MYSQLD/g" $INSTANCE/my.cnf
$sed -i "s/#instance#/$INSTANCE/g" $INSTANCE/my.cnf
$sed -i "s/#port#/$PORT/g" $INSTANCE/my.cnf
if [[ $MODE == "debug" || $MODE == "DEBUG" ]]; then
    sed -i "s/$MYSQLD/$MYSQLD-debug/g" $INSTANCE/my.cnf
fi

echo "=== [INFO] start $MYSQLD [$MODE] at $PORT"
if [[ $MODE == "debug" || $MODE == "DEBUG" ]]; then
    MYSQLD=${MYSQLD}-debug
fi
$WORK_DIR/mysqld/$MYSQLD/bin/mysqld_safe --defaults-file=$WORK_DIR/$INSTANCE/my.cnf >/dev/null 2>&1 &

echo "=== [INFO] enjoy!!!"
