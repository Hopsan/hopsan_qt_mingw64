#!/bin/bash

# Change these to suit your needs
buildroot=/c/Qt/build
mingw64dir=/c/Qt/x86_64-4.9.3-release-posix-seh-rt_v4-rev1/mingw64
icufile=icu4c-56_1-src.zip
makecommand=mingw32-make


# Automatic code starts here
cd $buildroot
unset MAKE_COMMAND
export PATH=$mingw64dir/bin:$PATH
unzip -o $icufile
cd icu/source
cp /usr/share/automake-1.15/config.guess .
cp /usr/share/automake-1.15/config.sub .
cp config/mh-mingw64 config/mh-unknown
./runConfigureICU MinGW prefix=$buildroot/icu/dist
make -j4 && make install
echo
echo buildICU.sh Done!
