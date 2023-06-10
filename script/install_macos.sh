#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
PARALLEL_NUM=16
# 检查cmake是否存在
if command -v cmake >/dev/null 2>&1; then 
  echo '已安装cmake' 
else 
  echo 'cmake尚未安装。PanGIS数据库安装脚本将退出。请安装好cmake后再运行此脚本'
  exit 
fi

mkdir ${CUR_DIR}/src
cd ${CUR_DIR}/src


#安装支持库


PGSQL_VERSION=15.3
GDAL_VERSION=release/3.7
PROJ_VERSION=9.2
GEOS_VERSION=main
POSTGIS_VERSION=stable-3.3
GEOTIFF_VERSION=master

# 下载源代码

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

echo "编译安装空间数据库"
INSTALL_PATH=${CUR_DIR}/build


echo "编译安装基础数据库postgresql"
tar -jvxf postgresql-${PGSQL_VERSION}.tar.bz2
cd postgresql-${PGSQL_VERSION}
./configure --prefix=$INSTALL_PATH --with-uuid=e2fs 
make 
make install
# 编译uuid扩展
cd contrib/uuid-ossp
make -j ${PARALLEL_NUM}
make install
cd ../../..


echo "编译安装geos"
mkdir geos/build
cd geos/build
cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release ..
make -j ${PARALLEL_NUM}
make install
cd ../..


echo "编译安装proj"
mkdir PROJ/build
cd PROJ/build
cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH \
	-DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..  
make -j ${PARALLEL_NUM}
make install
cd ../..


echo "编译安装libgeotiff"
mkdir libgeotiff/libgeotiff/build
cd libgeotiff/libgeotiff/build
cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH \
  -DCMAKE_BUILD_TYPE=Release -DPROJ_INCLUDE_DIR=$INSTALL_PATH/include 	\
  -DWITH_ZLIB=TRUE -DWITH_JPEG=TRUE ..
make -j ${PARALLEL_NUM}
make install
cd ../../..

echo "编译安装gdal"
mkdir GDAL/build
cd GDAL/build
cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH \
  -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..
make -j ${PARALLEL_NUM}
make install
cd ../..


echo "编译安装postgis"
cd postgis
./autogen.sh
export DYLD_LIBRARY_PATH=.:../lib:$INSTALL_PATH/lib:$DYLD_LIBRARY_PATH
# export LD_LIBRARY_PATH=.:../lib:$INSTALL_PATH/lib:$LD_LIBRARY_PATH
export PATH=.:$INSTALL_PATH/bin:$PATH
./configure --prefix=$INSTALL_PATH \
  --with-projdir=$INSTALL_PATH 
make -j ${PARALLEL_NUM}
make install
cd ..