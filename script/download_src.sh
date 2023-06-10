#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
PARALLEL_NUM=16




#安装支持库
sudo apt -y install build-essential cmake curl axel libpython3-dev python-dev-is-python3 libtool
# postgresql支持库
sudo apt -y install libreadline-dev libjson-c-dev libpcre2-dev
# uuid支持库
sudo apt -y install libossp-uuid-dev
#计算机图形算法库，空间分析（3D分析）
sudo apt -y install libcgal-dev libsfcgal-dev 
#编译libgeotiff需要的支持库
sudo apt -y install libjbig-dev libjbig0 libjpeg-dev libjpeg-turbo8 libjpeg-turbo8-dev libjpeg8 libjpeg8-dev 	\
  liblzma-dev libsqlite3-dev libtiff-dev libtiff5 libtiffxx5 libwebp-dev libpng-dev libqhull-dev swig 
# gdal需要安装hdf4、netcdf开发库才能读写相应文件格式
sudo apt -y install libgif-dev libcurl4-openssl-dev libhdf5-dev libhdf4-dev libnetcdf-dev
#proj4编译需要sqlite3的开发包
sudo apt -y install libsqlite3-dev sqlite3
# geos需要protobuf-c
sudo apt -y install protobuf-c-compiler libprotobuf-c-dev libprotobuf-dev protobuf-compiler
#postgis需要libxml2
sudo apt -y install libxml2-dev



mkdir ${CUR_DIR}/src
cd ${CUR_DIR}/src


echo "正在下载postgresql-${PGSQL_VERSION}.tar.bz2, 请等待..."
wget -c "https://ftp.postgresql.org/pub/source/v${PGSQL_VERSION}/postgresql-${PGSQL_VERSION}.tar.bz2"
echo "postgresql-${PGSQL_VERSION}.tar.bz2下载成功"

echo "从github下载gdal 版本分支: ${GDAL_VERSION}, 请等待..."
git clone https://github.com/OSGeo/GDAL.git -b ${GDAL_VERSION}
echo "gdal下载成功"

echo "从github下载proj 版本分支: ${PROJ_VERSION}, 请等待..."
git clone https://github.com/OSGeo/PROJ.git -b ${PROJ_VERSION}
echo "proj下载成功"

echo "从github下载geos 版本分支: ${GEOS_VERSION}, 请等待..."
git clone https://github.com/libgeos/geos.git -b ${GEOS_VERSION}
echo "geos下载成功"

echo "从github下载postgis 版本分支: ${POSTGIS_VERSION}, 请等待..."
git clone https://github.com/postgis/postgis.git -b ${POSTGIS_VERSION}
echo "postgis下载成功"

echo "从github下载libgeotiff 版本分支: ${GEOTIFF_VERSION}, 请等待..."
git clone https://github.com/OSGeo/libgeotiff.git -b ${GEOTIFF_VERSION}
echo "libgeotiff下载成功"


