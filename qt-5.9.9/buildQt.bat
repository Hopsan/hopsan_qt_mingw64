@echo off
REM This script is used to build the Qt framework using the MinGW-W64 compiler

setlocal
set buildroot=%~dp0

REM -----------------------------------------------------------------------
REM Settings. Change these to suit your needs
REM -----------------------------------------------------------------------

set mingw64_path=C:\hopsan-dev\x86_64-5.4.0-release-posix-seh-rt_v5-rev0\mingw64

set qt_src_name=qt-everywhere-opensource-src-5.9.9
set qt_src_suffix=zip
set target_install_dir=qt-5.9.9-x64-5.4.0-release-posix-seh-rt_v5-rev0

set qtbinpatcher_release=%buildroot%\qtbinpatcher-2.2.0-win-x64.zip
set openssl_version=1.0.2u
set icu_major_version=56
set icu_minor_version=2

REM Add tools to PATH
set PATH=C:\StrawberryPerl\c\bin;C:\Python27;C:\Program Files\7-Zip;%PATH%






REM -----------------------------------------------------------------------
REM Automatic code starts here
REM -----------------------------------------------------------------------
set icu_version=%icu_major_version%_%icu_minor_version%
set opensslpath=%buildroot%\openssl-%openssl_version%\dist
set icupath=%buildroot%\icu-%icu_version%\icu\dist
set installpath=%buildroot%\%target_install_dir%

REM Convert to forward slashes
set buildrootfwd=%buildroot:\=/%
set installpathfwd=%installpath:\=/%
set opensslpathfwd=%opensslpath:\=/%
set icupathfwd=%icupath:\=/%

echo ==============================
echo Paths
echo ==============================
echo buildrootfwd  : %buildrootfwd%
echo opensslpathfwd: %opensslpathfwd%
echo icupathfwd    : %icupathfwd%
echo installpathfwd: %installpathfwd%

cd /D %buildroot%
if not exist %qt_src_name% 7z.exe x %qt_src_name%.%qt_src_suffix% || echo Source directory already exist, does not unzip again, it takes to long

if not exist %qt_src_name%-build mkdir %qt_src_name%-build
cd /D %qt_src_name%-build

set PATH=%mingw64_path%\bin;%buildroot%\%qt_src_name%\qtbase\bin;%buildroot%\%qt_src_name%\gnuwin32\bin;%buildroot%\gnuwin32\bin;%icupath%\bin;%opensslpath%\bin;%PATH%

echo.
echo ==============================
echo Configuring
echo ==============================
set INCLUDE= 
set LIB= 
set QMAKESPEC=
set QTDIR=
set MAKE_COMMAND=

call %buildroot%\%qt_src_name%\configure.bat --list-features
call %buildroot%\%qt_src_name%\configure.bat -prefix %installpathfwd% -debug-and-release -opensource -confirm-license -platform win32-g++ -c++std c++14 -no-feature-quickcontrols2-material -no-feature-quickcontrols2-universal -no-feature-quicktemplates2-hover -no-feature-quicktemplates2-multitouch -no-feature-geoservices_mapbox -no-feature-geoservices_mapboxgl -no-feature-webrtc -icu -opengl desktop -openssl -plugin-sql-sqlite -qt-zlib -qt-libpng -qt-libjpeg -nomake tests -nomake examples -I %opensslpathfwd%/include -I %icupathfwd%/include -L %opensslpathfwd%/lib -L %icupathfwd%/lib -silent
REM -no-feature-geoservices_esri -no-feature-geoservices_here -no-feature-geoservices_itemsoverlay  -no-feature-geoservices_osm -no-feature-webrtc

echo.
echo ==============================
echo Building
echo ==============================
mingw32-make -j16

echo.
echo ==============================
echo Installing
echo ==============================
mkdir %installpath%
mingw32-make install
REM mingw32-make -j6 docs
REM mingw32-make -j6 install_docs

cd /D %buildroot%

REM Copy the dependencies dlls to the default installation directory (bin directory)
echo.
echo ==============================
echo Copying dependencies
echo ==============================
if exist %icupath%\bin (
  echo Copying ICU libs
  xcopy /Y %icupath%\bin\libicu*%icu_major_version%.dll %installpath%\bin
)
echo Copying OpenSSL libs
xcopy /Y %opensslpath%\bin\*.dll %installpath%\bin
echo Copying QtBinpatcher
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


:end
cd %buildroot%
echo.
echo buildQt.bat Done!
pause
endlocal
