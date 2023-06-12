#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
PARALLEL_NUM=16

mkdir ${CUR_DIR}/src
cd ${CUR_DIR}/src

sh ${CUR_DIR}/install_dependency.sh

sh ${CUR_DIR}/download_src.sh


echo "编译安装空间数据库"
BUILD_PATH=${CUR_DIR}/build
# export DYLD_LIBRARY_PATH=.:../lib:${BUILD_PATH}/lib:$DYLD_LIBRARY_PATH
export LD_LIBRARY_PATH=.:../lib:${BUILD_PATH}/lib:$LD_LIBRARY_PATH
export PATH=.:${BUILD_PATH}/bin:$PATH


echo "编译安装基础数据库postgresql"

cd postgresql
./configure --prefix=${BUILD_PATH} --with-ossp-uuid 
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
cmake -DCMAKE_INSTALL_PREFIX=${BUILD_PATH} -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release ..
make -j ${PARALLEL_NUM}
make install
cd ../..


echo "编译安装proj"
mkdir PROJ/build
cd PROJ/build
cmake -DCMAKE_INSTALL_PREFIX=${BUILD_PATH} \
	-DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..  
make -j ${PARALLEL_NUM}
make install
cd ../..


echo "编译安装libgeotiff"
mkdir libgeotiff/libgeotiff/build
cd libgeotiff/libgeotiff/build
cmake -DCMAKE_INSTALL_PREFIX=${BUILD_PATH} \
  -DCMAKE_BUILD_TYPE=Release -DPROJ_INCLUDE_DIR=${BUILD_PATH}/include 	\
  -DWITH_ZLIB=TRUE -DWITH_JPEG=TRUE ..
make -j ${PARALLEL_NUM}
make install
cd ../../..

echo "编译安装gdal"
mkdir GDAL/build
cd GDAL/build
cmake -DCMAKE_INSTALL_PREFIX=${BUILD_PATH} -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..
make -j ${PARALLEL_NUM}
make install
cd ../..


echo "编译安装postgis"
cd postgis
./autogen.sh
./configure --prefix=${BUILD_PATH} \
  --with-projdir=${BUILD_PATH} 
make -j ${PARALLEL_NUM}
make install
echo "为postgis二次开发，需要将.o目标文件打包成静态库libpostgis.a"
gcc -shared -o libpostgis.so liblwgeom/*.o libpgcommon/*.o deps/ryu/*.o
cp libpostgis.so ${BUILD_PATH}/lib
cd ..

PGSQL_INSTALL_PATH=/usr/local/pgsql
# 判断/etc/profile中是否已经添加PGSQL环境变量，如果没有则设置系统环境变量
i=`sed -n '/PGSQL/'p /etc/profile | wc -l`
if [ "$i" = '0' ]; then
  echo "" | sudo tee -a /etc/profile
  echo "export PGSQL=${PGSQL_INSTALL_PATH}" | sudo tee -a /etc/profile
  echo "export PATH=.:\$PGSQL/bin:\$PATH" | sudo tee -a /etc/profile
  echo "export LD_LIBRARY_PATH=.:\$PGSQL/lib:\$LD_LIBRARY_PATH" | sudo tee -a /etc/profile
  echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:\$PGSQL/lib/pkgconfig" | sudo tee -a /etc/profile  
fi



sudo mkdir ${PGSQL_INSTALL_PATH}
sudo cp -rf ${BUILD_PATH}/* ${PGSQL_INSTALL_PATH} 
sudo chmod -R 755 ${PGSQL_INSTALL_PATH}
echo "安装成功"

source /etc/profile
