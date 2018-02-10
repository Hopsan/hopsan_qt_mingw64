# hopsan_qt_mingw64
Build scripts for a custom version of the Qt libraries with QtWebKit compiled with MinGW64 for Hopsan

# Required Tools
- 7z
- Python2
- ActivePerl http://www.activestate.com/Products/activeperl/index.mhtml
- Msys2 (for .sh scripts)
- MinGW64 (whatever version you require)
  - Note! You must copy and rename (the copy) mingw32-make.exe into make.exe (you can remove this copy when you are done!)
- Qtbinpatcher (original github repo has been removed)
- GnuWin32 http://gnuwin32.sourceforge.net/packages.html (IMPORTANT! Install to a path without spaces (Not! in Program File (x86))
  - Gperf
  - Grep
  - Sed
- WinFlexBison https://github.com/lexxmark/winflexbison
  - https://sourceforge.net/projects/winflexbison/files/win_flex_bison-2.4.12.zip/download
  - Unpack wherever (without spaces), I abused c:\GnuWin32\bin 
  - Copy win_flex and win_bison to flex.exe and bison.exe (keep win_flex and win_bison)

# Required Dependencies 
Update OpenSSL at will but it must be 1.0.*
- OpenSSL https://www.openssl.org/source/openssl-1.0.2n.tar.gz
- ICU http://download.icu-project.org/files/icu4c/56.1/icu4c-56_1-src.zip

# Require Source Code
- Qt  https://download.qt.io/official_releases/qt/5.6/5.6.3/single/qt-everywhere-opensource-src-5.6.3.zip
- QtWebKit  https://download.qt.io/community_releases/5.6/5.6.3/qtwebkit-opensource-src-5.6.3.zip

# Build Instructions
- Unpack MinGW64 package to C:\hopsan-dev\x86_64-4.9.4-release-posix-seh-rt_v5-rev0 (or similar depending on version)
  - Copy mingw32-make according to instructions above
- Place downloaded dependencies in the same directory as the build scripts (and this file)
- Place downloaded source code zip or 7z in the same directory as the build scripts (and this file)
- Build OpenSSL and ICU first in a Msys2 shell, you may need to install a bunch of packages first. Let the build errors guide you.
- Build Qt by launching the buildQt.bat script in a Windows terminal (CMD)
- Build QtWebKit by launching the buildQtWebKit.bat script in a Windows terminal (CMD)

# Installation
- Unpack the resulting .7z archive wherever you want and then run the QtBinPatcher.exe
- If you ever move the files, you must rerun the QtBinPatcher.exe
