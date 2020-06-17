# my_scripts

## MySQL

deploy a mysql 5.7 instance, the init data file and `my.cnf` template is in demo dir.
mysqld is not here, you should build from source.

*How to build mysqld*  
https://dev.mysql.com/doc/refman/5.7/en/installing-source-distribution.html

1. `mkdir build && cd build`
2. Build release: `make -DCMAKE_INSTALL_PREFIX=release_out -DWITH_BOOST=~/code/boost_1_59_0 ..`
   Build debug: `make -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=debug_out -DWITH_BOOST=~/code/boost_1_59_0 ..`
3. `make -j 8`
4. `make install`
5. all files has in release_out or debug_out

### How to use

1. `tar -zxvf demo.tgz`
2. build or download the mysql release|debug file: `mysql-5.7.30` and `5.7.30-debug`
3. `mkdir mysqld`
4. `mv mysql-5.7.30 mysqld`, `mv mysql-5.7.30-debug mysqld`
5. `deploy_mysql.sh debug test 3307`

connect mysql: `mysql -h127.0.0.1 -uroot -P3307 -p123456`
