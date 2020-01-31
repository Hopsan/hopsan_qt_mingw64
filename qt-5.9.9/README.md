# Qt with QtWebKit using MinGW-W64 for use with Hopsan
Build scripts for a custom version of the Qt libraries with QtWebKit compiled with MinGW64 for Hopsan

# Required Tools
BUILDROOT is the directory of thei README.md file
- 7z (intalled to C:\Program Files\7-Zip)
- Python2 (install to C:\Python27)
- StrawberryPerl (install to C:\StrawberryPerl)
- Msys2 for .sh scripts, Install to MSYS64)
- MinGW64 (whatever version you want to use) In this case "GCC 5.4.0 x86_64-posix-seh" was used.
  https://sourceforge.net/projects/mingw-w64/files/Toolchains targetting Win64/Personal Builds/mingw-builds
- GnuWin32 https://sourceforge.net/projects/gnuwin32/files (Unpack to BUILDROOT/gnuwin32)
  - Grep (bin and deps)
  - Sed (bin snd deps)
- WinFlexBison https://github.com/lexxmark/winflexbison (Unpack to BUILDROOT/win_flex_bison)
- Ruby https://rubyinstaller.org/ install to BUILDROOT/rubyinstaller-2.6.5-1-x64
- Qtbinpatcher (original github repo has been removed)
  - Or optionally https://github.com/Fsu0413/QQtPatcher

# Required Dependencies
OpenSSL must be latest 1.0.*, newer version will not work
- OpenSSL https://www.openssl.org/source/openssl-1.0.2u.tar.gz
- ICU http://download.icu-project.org/files/icu4c/56.2/icu4c-56_2-src.zip

# Require Qt and WebKit Source Code
- Qt  https://download.qt.io/official_releases/qt/5.9/5.9.9/single/qt-everywhere-opensource-src-5.9.9.zip
- QtWebKit  https://github.com/qt/qtwebkit.git checkout branch 5.9

# Build Instructions
- Unpack MinGW64 package to C:\hopsan-dev\x86_64-5.4.0-release-posix-seh-rt_v5-rev0 (or similar depending on version)
- Place downloaded dependencies in the same directory as the build scripts (and this file)
- Place downloaded Qt source code zip in the same directory as the build scripts (and this file)
- Git clone the webkit code and checkout branch 5.9
- Build OpenSSL and ICU first using the .sh scripts in a Msys2 shell, you may need to install a bunch of packages first. Let the build errors guide you.
- Build Qt by launching the buildQt.bat script in a Windows terminal (CMD)
- Build QtWebKit by launching the buildQtWebKit.bat script in a Windows terminal (CMD)
- There should now be a 7z archive containing the build Qt and WebKit files

# Installation
- Unpack the resulting .7z archive wherever you want and then run the QtBinPatcher.exe
- If you ever move the files, you must rerun the QtBinPatcher.exe
