#!/bin/bash

buildroot=$(dirname $(readlink -f $0))

# Change these to suit your needs
mingw64_path=/c/hopsan-dev/x86_64-5.4.0-release-posix-seh-rt_v5-rev0/mingw64

icu_version=56_2
icu_source=${buildroot}/icu4c-${icu_version}-src.zip


# Automatic code starts here
cd $buildroot
unset MAKE_COMMAND
export PATH=$mingw64_path/bin:$PATH

mkdir -p icu-${icu_version}
cd icu-${icu_version}
unzip -o $icu_source

patch -p0 -i ${buildroot}/icu-patches/0004-move-to-bin.mingw.patch
patch -p0 -i ${buildroot}/icu-patches/0007-actually-move-to-bin.mingw.patch
patch -p0 -i ${buildroot}/icu-patches/0008-data-install-dir.mingw.patch
patch -p0 -i ${buildroot}/icu-patches/0009-fix-bindir-in-config.mingw.patch
patch -p0 -i ${buildroot}/icu-patches/0010-msys-rules-for-makefiles.mingw.patch
patch -p0 -i ${buildroot}/icu-patches/0011-sbin-dir.mingw.patch
patch -p0 -i ${buildroot}/icu-patches/0012-libprefix.mingw.patch
patch -p0 -i ${buildroot}/icu-patches/0014-mingwize-pkgdata.mingw.patch
patch -p0 -i ${buildroot}/icu-patches/0015-debug.mingw.patch
patch -p0 -i ${buildroot}/icu-patches/0016-icu-pkgconfig.patch
patch -p0 -i ${buildroot}/icu-patches/0017-icu-config-versioning.patch

cd icu/source
cp config/mh-mingw64 config/mh-unknown
./runConfigureICU MinGW prefix=$buildroot/icu-${icu_version}/icu/dist

make -j16 && make install

echo
echo buildICU.sh Done!
