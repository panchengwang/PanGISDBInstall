#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)


mkdir ${CUR_DIR}/src
cd ${CUR_DIR}/src

PGSQL_VERSION=15.3
GDAL_VERSION=release/3.7
PROJ_VERSION=9.2
GEOS_VERSION=main
POSTGIS_VERSION=stable-3.3
GEOTIFF_VERSION=master

echo "正在下载postgresql-${PGSQL_VERSION}.tar.bz2, 请等待..."
wget -c "https://ftp.postgresql.org/pub/source/v${PGSQL_VERSION}/postgresql-${PGSQL_VERSION}.tar.bz2"
rm -rf postgresql
tar -jvxf `ls postgresql*.tar.bz2`
mv `ls -d */ | grep "postgresql" | sed "s/\///"` postgresql
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

# echo "从github下载postgis 版本分支: ${POSTGIS_VERSION}, 请等待..."
# git clone https://git.osgeo.org/gitea/postgis/postgis.git -b ${POSTGIS_VERSION}
# echo "postgis下载成功"

echo "postgis的github代码没有定义好control文件，使用create extension出错"
echo "需要下载https://download.osgeo.org/postgis/source/postgis-3.3.3.tar.gz"
wget -c https://download.osgeo.org/postgis/source/postgis-3.3.3.tar.gz
rm -rf postgis
tar -zvxf `ls postgis*.tar.gz`
mv `ls -d */ | grep "postgis" | sed "s/\///"` postgis
echo 

echo "从github下载libgeotiff 版本分支: ${GEOTIFF_VERSION}, 请等待..."
git clone https://github.com/OSGeo/libgeotiff.git -b ${GEOTIFF_VERSION}
echo "libgeotiff下载成功"


