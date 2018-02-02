@echo off
REM This script is used to build the Qt framework using the MinGW-W64 compiler
REM Author: Peter Nordin

REM Change these to suit your needs
set buildroot=c:\Qt\build
set mingw64dir=c:\Qt\x86_64-4.9.3-release-posix-seh-rt_v4-rev1\mingw64
set srcname=qt-everywhere-opensource-src-5.6.3
set srcsuffix=zip
set installdirname=qt-5.6.3-x64-mingw493r4-seh-rev1
set opensslpath=%buildroot%\openssl-1.0.2n\dist
set icuversion=56
set icupath=%buildroot%\icu\dist

REM Automatic code starts here

set installpath=%buildroot%\%installdirname%

REM Convert to forward slashes
set buildrootfwd=%buildroot:\=/%
set installpathfwd=%installpath:\=/%
set opensslpathfwd=%opensslpath:\=/%
set icupathfwd=%icupath:\=/%

set PATH=C:\Perl64\bin;C:\Python27;C:\Program Files\7-Zip;%PATH%

cd /D %buildroot%
if not exist %srcname% 7z.exe x %srcname%.%srcsuffix% || echo Source directory already exist, does not unzip again, it takes to long

if not exist %srcname%-build mkdir %srcname%-build
cd /D %srcname%-build

set PATH=%mingw64dir%\bin;%buildroot%\%srcname%\qtbase\bin;%buildroot%\%srcname%\gnuwin32\bin;%icupath%\lib;%opensslpath%\bin;%PATH%
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
call %buildroot%\%srcname%\configure.bat -prefix %installpathfwd% -debug-and-release -opensource -confirm-license -platform win32-g++ -c++11 -opengl desktop -openssl -dbus -audio-backend -plugin-sql-sqlite -qt-zlib -qt-libpng -qt-libjpeg -nomake tests -nomake examples -I %opensslpathfwd%/include -L %opensslpathfwd%/lib

echo.
echo ==============================
echo Building and installing
echo ==============================
mingw32-make -j4
mingw32-make -j4 install
REM mingw32-make -j4 docs
REM mingw32-make -j4 install_docs

cd /D %buildroot%

REM Copy the dependencies to the default installation directory (qtbase\bin)
echo.
echo ==============================
echo Copying dependencies
echo ==============================
if exist %icupath%\lib (
  echo Copying ICU libs
  xcopy /Y %icupath%\lib\icu*%icuversion%.dll %installpath%\bin\
)
xcopy /Y %opensslpath%\bin\*.dll %installpath%\bin
7z x %buildroot%\qtbinpatcher-2.2.0-win-x64.zip qtbinpatcher.exe
move /Y qtbinpatcher.exe %installpath%

REM Package the release into a 7z archive
echo.
echo ==============================
echo Packaging release (compress with 7z)
echo ==============================
if exist %installdirname%.7z (
  echo Deleteing old %installdirname%.7z
  del /Q %installdirname%.7z
)
7z a -mx7 %installdirname%.7z %installdirname%

echo.
echo buildQt.bat Done!
pause
