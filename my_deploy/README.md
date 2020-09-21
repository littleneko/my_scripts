# my_scripts

## MySQL

Deploy a mysql 5.7 instance, the init data file and `my.cnf` template is in demo dir.
mysqld is not here, you should build from source.

*How to build mysqld*  
https://dev.mysql.com/doc/refman/5.7/en/installing-source-distribution.html

1. download boost 1.59.0: https://sourceforge.net/projects/boost/files/boost/1.59.0/
1. get mysql-server source: `git clone https://github.com/mysql/mysql-server.git`
1. checkout to 5.7: `git checkout 5.7`
1. `mkdir build && cd build`
1. Build release: `make -DCMAKE_INSTALL_PREFIX=release_out -DWITH_BOOST=/path/to/boost_1_59_0 ..`  
   Build debug: `make -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=debug_out -DWITH_BOOST=/path/to/boost_1_59_0 ..`
1. `make -j 8`
. `make install`
1. all files has in `release_out` or `debug_out` dir

### How to use

1. `git clone `
1. download the MySQL Community Server Compressed TAR Archive from [oracle](https://downloads.mysql.com/archives/community/), or build yourself.
1. uncompress the package and mv it to mysqld.
1. `tar -zxvf demo.tgz`
1. `deploy_mysql.sh debug test 3307`

connect to mysql: `mysql -h127.0.0.1 -uroot -P3307 -p123456`

# For MacOS User
```
brew install gnu-sed
brew install coreutils
```
