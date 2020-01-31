@echo off
setlocal
set buildroot=%~dp0

REM -----------------------------------------------------------------------
REM Settings. Change these to suit your needs
REM -----------------------------------------------------------------------

set mingw64_path=C:\hopsan-dev\x86_64-5.4.0-release-posix-seh-rt_v5-rev0\mingw64

set webkit_src_dir=qtwebkit
set qt_src_dir=qt-everywhere-opensource-src-5.9.9
set qt_install_dir=qt-5.9.9-x64-5.4.0-release-posix-seh-rt_v5-rev0

set gnuwin32_path=%buildroot%\gnuwin32\bin
set qt_gnuwin32_path=%buildroot%\%qt_src_dir%\gnuwin32\bin
set win_flex_bison_path=%buildroot%\win_flex_bison
set QTDIR=%buildroot%\%qt_install_dir%
set SQLITE3SRCDIR=%buildroot%\%qt_src_dir%\qtbase\src\3rdparty\sqlite





REM -----------------------------------------------------------------------
REM Automatic code starts here
REM -----------------------------------------------------------------------

set PATH=%QTDIR%\bin;%win_flex_bison_path%;%gnuwin32_path%;%qt_gnuwin32_path%;%mingw64_path%\bin;%buildroot%\rubyinstaller-2.6.5-1-x64\bin;C:\StrawberryPerl\c\bin;C:\Python27;C:\Program Files\7-Zip;C:\Program Files\CMake\bin;%PATH%

REM Make sure that make.exe exists
echo f|xcopy /Y %mingw64_path%\bin\mingw32-make.exe %mingw64_path%\bin\make.exe

cd /D %buildroot%
if not exist %webkit_src_dir% 7z.exe x %webkit_src_dir%.zip || echo Source directory already exist, does not unzip again, it takes to long
cd %webkit_src_dir%

REM Add missing include (only problem in debug mode)
sed "/#include \"Settings.h\"/a#include <wtf/text/CString.h>" -i Source/WebCore/loader/icon/IconController.cpp

REM Remove multimedia, sensors and positioning
sed "/qtHaveModule(positioning): WEBKIT_CONFIG += have_qtpositioning/d" -i Tools\qmake\mkspecs\features\features.prf
sed "/qtHaveModule(sensors): WEBKIT_CONFIG += have_qtsensors/d" -i Tools\qmake\mkspecs\features\features.prf
sed "/WEBKIT_CONFIG += video use_qt_multimedia/d" -i Tools\qmake\mkspecs\features\features.prf

echo.
echo ==============================
echo Building
echo ==============================
perl Tools\Scripts\build-webkit --qt --debug   --minimal --no-webkit2 --install-headers=%QTDIR%\include --install-libs=%QTDIR%\lib --qmakearg="DEFINES+=\"ENABLE_PLUGIN_PACKAGE_SIMPLE_HASH=1\"" --qmakearg="QMAKE_CXXFLAGS+=-Wa,-mbig-obj"
if ERRORLEVEL 1 goto end
perl Tools\Scripts\build-webkit --qt --release --minimal --no-webkit2 --install-headers=%QTDIR%\include --install-libs=%QTDIR%\lib --qmakearg="DEFINES+=\"ENABLE_PLUGIN_PACKAGE_SIMPLE_HASH=1\""
if ERRORLEVEL 1 goto end

echo.
echo ==============================
echo Installing
echo ==============================
perl Tools\Scripts\build-webkit --qt --debug   --minimal --no-webkit2 --install-headers=%QTDIR%\include --install-libs=%QTDIR%\lib --qmakearg="DEFINES+=\"ENABLE_PLUGIN_PACKAGE_SIMPLE_HASH=1\"" --makeargs="install"
if ERRORLEVEL 1 goto end
perl Tools\Scripts\build-webkit --qt --release --minimal --no-webkit2 --install-headers=%QTDIR%\include --install-libs=%QTDIR%\lib --qmakearg="DEFINES+=\"ENABLE_PLUGIN_PACKAGE_SIMPLE_HASH=1\"" --makeargs="install"
if ERRORLEVEL 1 goto end

REM Package the release into a 7z archive
cd %buildroot%
echo.
echo ==============================
echo Packaging release (compress with 7z)
echo ==============================
set target_z7_name=%qt_install_dir%-webkit.7z
if exist %target_z7_name% (
  echo Deleteing old %target_z7_name%
  del /Q %target_z7_name%
)
7z a -mx7 %target_z7_name% %qt_install_dir%

:end
cd %buildroot%
echo.
echo buildWebKit.bat Done!
pause
endlocal
