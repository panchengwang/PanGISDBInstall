#!/bin/sh
# 检查cmake是否存在
if command -v cmake >/dev/null 2>&1; then 
  echo '已安装cmake' 
else 
  echo 'cmake尚未安装。PanGIS数据库安装脚本将退出。请安装好cmake后再运行此脚本'
  exit 
fi

PGSQL_VERSION=15.3
GDAL_VERSION=3.7.0
# 下载源代码
mkdir src
cd src
# echo "正在下载postgresql-${PGSQL_VERSION}.tar.bz2, 请等待..."
# wget -c "https://ftp.postgresql.org/pub/source/v${PGSQL_VERSION}/postgresql-${PGSQL_VERSION}.tar.bz2"
# echo "postgresql-${PGSQL_VERSION}.tar.bz2下载成功"

echo "正在下载gdal-${GDAL_VERSION}.tar.gz, 请等待..."
wget -c "https://github.com/OSGeo/gdal/releases/download/v${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz"
echo "gdal-${GDAL_VERSION}.tar.gz下载成功"