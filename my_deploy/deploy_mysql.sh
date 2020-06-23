#!/usr/bin/env bash

FILE_PATH=`readlink -f $0`
WORK_DIR=`dirname ${FILE_PATH}`
echo "=== WORK_DIR: $WORK_DIR"

MYSQLD="mysql-5.7.30"
INSTANCE="test"
PORT=3306
MODE=RELEASE

if [[ $# == 2 ]]; then
    INSTANCE=$1
    PORT=$2
elif [[ $# == 3 ]]; then
    MODE=$1
    INSTANCE=$2
    PORT=$3
else
    echo "usage: $0 [debug/release, default is release] instance_name port"
    exit
fi

echo "=== INFO: check instance name: $INSTANCE"
if [[ -d $INSTANCE ]]; then
    echo "=== ERROR: dir $1 exist"
    exit
fi

echo "=== INFO: check port: $PORT"
pIDa=`/usr/sbin/lsof -i :$PORT|grep -v "PID" | awk '{print $PORT}'`
if [ "$pIDa" != "" ]; then
   echo "=== ERROR: port $PORT used by $pIDa"
   exit
fi


echo "=== INFO: deploy $MYSQLD $MODE in [$INSTANCE], listen on $PORT"

echo "=== INFO: cp data to $INSTANCE"
cp -r demo $INSTANCE
cp $INSTANCE/my.cnf.temp $INSTANCE/my.cnf

echo "=== INFO: modify my.cnf"
BASE_DIR=`echo $WORK_DIR|sed 's/\//\\\\\//g'`
sed -i "s/#base_dir#/$BASE_DIR/g" $INSTANCE/my.cnf
sed -i "s/#instance#/$INSTANCE/g" $INSTANCE/my.cnf
sed -i "s/#port#/$PORT/g" $INSTANCE/my.cnf
if [[ $MODE == "debug" || $MODE == "DEBUG" ]]; then
    sed -i "s/$MYSQLD/$MYSQLD-debug/g" $INSTANCE/my.cnf
fi

echo "=== INFO: start $MYSQLD [$MODE] at $PORT"
if [[ $MODE == "debug" || $MODE == "DEBUG" ]]; then
    MYSQLD=${MYSQLD}-debug
fi
$WORK_DIR/mysqld/$MYSQLD/bin/mysqld_safe --defaults-file=/data1/mysql/$INSTANCE/my.cnf >/dev/null 2>&1 &

echo "=== enjoy!!!"
