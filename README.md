# hopsan_qt_mingw64
Build scripts for a custom version of the Qt libraries compiled with MinGW64 for Hopsan

# Required Tools
- Python2
- ActivePerl http://www.activestate.com/Products/activeperl/index.mhtml
- Msys2 (for .sh scripts)
- MinGW64
- Qtbinpatcher (original github repo removed)

# Required dependencies
- OpenSSL https://www.openssl.org/source/openssl-1.0.2n.tar.gz
- ICU http://download.icu-project.org/files/icu4c/56.1/icu4c-56_1-src.zip

# Require source code
- Qt  https://download.qt.io/official_releases/qt/5.6/5.6.3/single/qt-everywhere-opensource-src-5.6.3.zip

# Instructions
Unpack MinGW64 package to C:\Qt\x86_64-4.9.3-release-posix-seh-rt_v4-rev1 (or similar depending on version)
Place downloaded dependencies in the same directory as the scripts (and this file)
Place downloaded source code zip or 7z in the same directory as the scripts (and this file)
Build OpenSSL and ICU first in a msys2 shell, you may need to install a bunch of packages first. Let the build errors guide you.
Build Qt by launching the .bat script in a Windows terminal (CMD)
