#!/bin/bash

# Change these to suit your needs
buildroot=$(dirname $(readlink -f $0))
mingw64_path=/c/hopsan-dev/x86_64-4.9.4-release-posix-seh-rt_v5-rev0/mingw64
openssl_name=openssl-1.0.2n


# Automatic code starts here
cd $buildroot
unset MAKE_COMMAND MAKEFLAGS
export PATH="$mingw64_path/bin:$PATH"
tar -xvzf $openssl_name.tar.gz
cd $openssl_name
./Configure --prefix=$buildroot/$openssl_name/dist no-idea no-mdc2 no-rc5 shared mingw64
make depend && make -j6 && make install
echo
echo buildOpenSSL.sh Done!
