#!/bin/sh

echo "Ubuntu20.04系统：PostGIS源码编译工具及依赖库安装"
echo "作者：麓山老将pcwang"


CUR_DIR=$(cd $(dirname $0); pwd)

echo "编译工具: build-essential cmake curl axel libpython3-dev python-dev-is-python3 libtool"
sudo apt -y install build-essential cmake curl axel libpython3-dev python-dev-is-python3 libtool

# postgresql支持库
echo "postgresql支持库: libreadline-dev libjson-c-dev libpcre2-dev"
sudo apt -y install libreadline-dev libjson-c-dev libpcre2-dev

# uuid支持库
echo "uuid支持库: libossp-uuid-dev"
sudo apt -y install libossp-uuid-dev

#计算机图形算法库，空间分析（3D分析）
echo "计算机图形算法库，空间分析（3D分析）: libcgal-dev libsfcgal-dev"
sudo apt -y install libcgal-dev libsfcgal-dev 

#编译libgeotiff需要的支持库
echo "libgeotiff支持库: libjbig-dev libjbig0 libjpeg-dev libjpeg-turbo8 libjpeg-turbo8-dev libjpeg8 libjpeg8-dev liblzma-dev libsqlite3-dev libtiff-dev libtiff5 libtiffxx5 libwebp-dev libpng-dev libqhull-dev swig"
sudo apt -y install libjbig-dev libjbig0 libjpeg-dev libjpeg-turbo8 libjpeg-turbo8-dev libjpeg8 libjpeg8-dev 	\
  liblzma-dev libsqlite3-dev libtiff-dev libtiff5 libtiffxx5 libwebp-dev libpng-dev libqhull-dev swig 

# gdal需要安装hdf4、netcdf开发库才能读写相应文件格式
echo "gdal支持库: libgif-dev libcurl4-openssl-dev libhdf5-dev libhdf4-dev libnetcdf-dev"
sudo apt -y install libgif-dev libcurl4-openssl-dev libhdf5-dev libhdf4-dev libnetcdf-dev

#proj4编译需要sqlite3的开发包
echo "proj4编译需要sqlite3的开发包: libsqlite3-dev sqlite3"
sudo apt -y install libsqlite3-dev sqlite3

# geos需要protobuf-c
echo "geos需要protobuf-c: protobuf-c-compiler libprotobuf-c-dev libprotobuf-dev protobuf-compiler"
sudo apt -y install protobuf-c-compiler libprotobuf-c-dev libprotobuf-dev protobuf-compiler

#postgis需要libxml2
sudo "postgis需要libxml2: libxml2-dev"
sudo apt -y install libxml2-dev