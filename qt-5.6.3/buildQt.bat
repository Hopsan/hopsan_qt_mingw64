@echo off
REM This script is used to build the Qt framework using the MinGW-W64 compiler
REM Author: Peter Nordin

REM -----------------------------------------------------------------------
REM Settings. Change these to suit your needs
REM -----------------------------------------------------------------------
set buildroot=%~dp0

set target_install_dir=qt-5.6.3-x64-mingw494-posix-seh-rt_v5-rev0

set mingw64_path=C:\hopsan-dev\x86_64-4.9.4-release-posix-seh-rt_v5-rev0\mingw64
set qt_src_name=qt-everywhere-opensource-src-5.6.3
set qt_src_suffix=zip

set qtbinpatcher_release=%buildroot%\qtbinpatcher-2.2.0-win-x64.zip
set openssl_name=openssl-1.0.2n
set icu_version=56

REM Add tools to PATH
set PATH=C:\Perl64\bin;C:\Python27;C:\Program Files\7-Zip;%PATH%

REM -----------------------------------------------------------------------




REM -----------------------------------------------------------------------
REM Automatic code starts here
REM -----------------------------------------------------------------------

set opensslpath=%buildroot%\%openssl_name%\dist
set icupath=%buildroot%\icu\dist
set installpath=%buildroot%\%target_install_dir%

REM Convert to forward slashes
set buildrootfwd=%buildroot:\=/%
set installpathfwd=%installpath:\=/%
set opensslpathfwd=%opensslpath:\=/%
set icupathfwd=%icupath:\=/%

cd /D %buildroot%
if not exist %qt_src_name% 7z.exe x %qt_src_name%.%qt_src_suffix% || echo Source directory already exist, does not unzip again, it takes to long

if not exist %qt_src_name%-build mkdir %qt_src_name%-build
cd /D %qt_src_name%-build

set PATH=%mingw64_path%\bin;%buildroot%\%qt_src_name%\qtbase\bin;%buildroot%\%qt_src_name%\gnuwin32\bin;%icupath%\lib;%opensslpath%\bin;%PATH%
echo.
echo ==============================
echo Configuring
echo ==============================
set INCLUDE= 
set LIB= 
set QMAKESPEC=
set QTDIR=
set MAKE_COMMAND=
REM call configure.bat -prefix %installpathfwd% -debug-and-release -opensource -confirm-license -platform win32-g++ -c++11 -icu -opengl desktop -openssl -dbus -audio-backend -plugin-sql-sqlite -qt-zlib -qt-libpng -qt-libjpeg -qt-style-windowsxp -qt-style-windowsvista -nomake tests -nomake examples -I %icupathfwd%/include -I %opensslpathfwd%/include -L %icupathfwd%/lib -L %opensslpathfwd%/lib
call %buildroot%\%qt_src_name%\configure.bat -prefix %installpathfwd% -debug-and-release -opensource -confirm-license -platform win32-g++ -c++11 -icu -opengl desktop -openssl -dbus -audio-backend -plugin-sql-sqlite -qt-zlib -qt-libpng -qt-libjpeg -nomake tests -nomake examples -I %opensslpathfwd%/include -I %icupathfwd%/include -L %opensslpathfwd%/lib -L %icupathfwd%/lib

echo.
echo ==============================
echo Building and installing
echo ==============================
mingw32-make -j6
mingw32-make -j6 install
REM mingw32-make -j6 docs
REM mingw32-make -j6 install_docs

cd /D %buildroot%

REM Copy the dependencies to the default installation directory (qtbase\bin)
echo.
echo ==============================
echo Copying dependencies
echo ==============================
if exist %icupath%\lib (
  echo Copying ICU libs
  xcopy /Y %icupath%\lib\icu*%icu_version%.dll %installpath%\bin\
)
xcopy /Y %opensslpath%\bin\*.dll %installpath%\bin
7z x %qtbinpatcher_release% qtbinpatcher.exe
move /Y qtbinpatcher.exe %installpath%

REM Package the release into a 7z archive
echo.
echo ==============================
echo Packaging release (compress with 7z)
echo ==============================
if exist %target_install_dir%.7z (
  echo Deleteing old %target_install_dir%.7z
  del /Q %target_install_dir%.7z
)
7z a -mx7 %target_install_dir%.7z %target_install_dir%

echo.
echo buildQt.bat Done!
pause
