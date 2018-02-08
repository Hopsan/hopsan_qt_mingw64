@echo off
set buildroot=%~dp0


set mingw64_path=C:\hopsan-dev\x86_64-4.9.4-release-posix-seh-rt_v5-rev0\mingw64

set webkit_src_dir=qtwebkit-opensource-src-5.6.3
set qt_src_dir=qt-everywhere-opensource-src-5.6.3
set qt_install_dir=qt-5.6.3-x64-mingw494-posix-seh-rt_v5-rev0

set QTDIR=%buildroot%\%qt_install_dir%
set SQLITE3SRCDIR=%buildroot%\%qt_src_dir%\qtbase\src\3rdparty\sqlite

set PATH=C:\GnuWin32\bin;%mingw64_path%\bin;%QTDIR%\bin;C:\Perl64\bin;C:\Python27;C:\Ruby21-x64\bin;C:\Program Files\7-Zip;%PATH%

cd %webkit_src_dir%
REM set MAKE_COMMAND=mingw32-make -j6
perl Tools\Scripts\build-webkit --qt --release --minimal --no-webkit2

REM Copy (install) into Qt directory
robocopy include %QTDIR%\include /E
robocopy WebKitBuild\Release\lib %QTDIR%\bin *.dll
robocopy WebKitBuild\Release\lib %QTDIR%\lib *.a
robocopy WebKitBuild\Release\lib %QTDIR%\lib *.prl
robocopy WebKitBuild\Release\lib\pkgconfig %QTDIR%\lib\pkgconfig /E
robocopy WebKitBuild\Release\lib\cmake %QTDIR%\lib\cmake /E

REM Package the release into a 7z archive
cd %buildroot%
echo.
echo ==============================
echo Packaging release (compress with 7z)
echo ==============================
set target_z7_name=%qt_install_dir%.7z
if exist %target_z7_name% (
  echo Deleteing old %target_z7_name%
  del /Q %target_z7_name%
)
7z a -mx7 %target_z7_name% %qt_install_dir%

echo.
echo buildWebKit.bat Done!
REM cmd
pause
