# 我的工具集

自己的一些常用工具

## install_docker.sh

在Centos7 or ubuntu上安装docker

```
curl -sSL https://gitee.com/x2x4/mytools/raw/master/install_docker.sh | sudo bash
```

## install_nginx.sh

CentOS/Ubuntu 上编译安装NGINX

```
source <(curl -fsSL http://git.oschina.net/x2x4/mytools/raw/master/install_nginx.sh)
```

## install_nginx_service.sh

为系统配置基于systemctl的nginx启动文件，请克隆仓库后执行


## install_php7.sh

CentOS/Ubuntu 编译安装PHP7.1.2


```
source <(curl -fsSL http://git.oschina.net/x2x4/mytools/raw/master/install_php7.sh) 
```

## get_db_schema.py

自动获取数据库结构并生成excel文件

需要python3

依赖openpyxl与pymysql

```
pip install pymysql openpyxl
```

Usage:

```
python3 get_db_schema.py -h
===================================
Usage: get_db_schema.py [ OPTIONS ]

Options:
    -H [--host=]  :  MySQL Host
    -P [--port=]  :  MySQL Port
    -u [--user=]  :  MySQL User, Need Read Information_schema
    -p [--pass=]  :  User password
    -d [--db=]    :  Which db you need dump
    -l [--lang=]  :  Column language[todo]
    -o [--output=]:  file to save

```

Example:

```bash
python3 get_db_schema.py -H 192.168.1.12 -u bidpoc -d bidpoc -p somepassword
Port not define, use default, 3306
Lang not define, use default, zhCN
Output not define, save to default, db_schema_bidpoc_2017-09-08_172925.xlsx
save to db_schema_bidpoc_2017-09-08_172925.xlsx
```


## matrix_cal_table.py

生成一个矩阵表格，给儿子做算术题训练，依赖openpyxl


## UpdateHook.py

用于oschina的webhook回调，python版本

依赖Flask，请先安装

```bash
pip install flask
```


