#!/bin/bash

# Change these to suit your needs
buildroot=$(dirname $(readlink -f $0))
mingw64_path=/c/hopsan-dev/x86_64-4.9.4-release-posix-seh-rt_v5-rev0/mingw64
icu_source=icu4c-56_1-src.zip


# Automatic code starts here
cd $buildroot
unset MAKE_COMMAND
export PATH=$mingw64_path/bin:$PATH
unzip -o $icu_source
cd icu/source
cp /usr/share/automake-1.15/config.guess .
cp /usr/share/automake-1.15/config.sub .
cp config/mh-mingw64 config/mh-unknown
./runConfigureICU MinGW prefix=$buildroot/icu/dist
make -j6 && make install
echo
echo buildICU.sh Done!
