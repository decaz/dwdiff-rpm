#!/bin/bash
set -eux

yum update -y
yum install -y \
	wget \
	bzip2 \
	make \
	gcc \
	gettext \
	libicu-devel \
	rpm-build \
	ruby-devel

# Install FPM
gem install --no-ri --no-rdoc fpm

# Download sources
wget -O dwdiff.tar.bz2 https://os.ghalkes.nl/dist/dwdiff-${DWDIFF_VERSION}.tar.bz2
mkdir -p ${BUILD_DIR}
tar -xjC ${BUILD_DIR} --strip-components=1 -f dwdiff.tar.bz2

# Build sources
cd ${BUILD_DIR}
./configure
make all
make install DESTDIR=/tmp/installdir

# Build RPM
fpm \
	-t rpm \
	-s dir \
	-C /tmp/installdir \
	-n dwdiff \
	-v ${DWDIFF_VERSION} \
	-d "libicu" \
	usr/local
