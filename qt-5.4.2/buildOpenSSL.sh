#!/bin/bash

# Change these to suit your needs
buildroot=/c/Qt/build
mingw64dir=/c/Qt/x86_64-4.9.3-release-posix-seh-rt_v4-rev1/mingw64
opensslname=openssl-1.0.2e


# Automatic code starts here
cd $buildroot/deps
unset MAKE_COMMAND MAKEFLAGS
export PATH="$mingw64dir/bin:$PATH"
tar -xvzf $opensslname.tar.gz
cd $opensslname
./Configure --prefix=$buildroot/deps/$opensslname/dist no-idea no-mdc2 no-rc5 shared mingw64
make depend && make -j4 && make install
echo
echo buildOpenSSL.sh Done!
