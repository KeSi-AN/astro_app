@echo off
rem Builds sweph.dll for running jyotish_core tests on Windows (the phone build compiles it via the Flutter plugin).
rem Output: packages\jyotish_core\native\sweph.dll  (git-ignored)
setlocal
set VCVARS="C:\Program Files\Microsoft Visual Studio\2022\Preview\VC\Auxiliary\Build\vcvars64.bat"
for /f "delims=" %%d in ('dir /b /ad /o-n "%LOCALAPPDATA%\Pub\Cache\hosted\pub.dev\sweph-*"') do (set SWEPH=%LOCALAPPDATA%\Pub\Cache\hosted\pub.dev\%%d& goto found)
:found
echo Using %SWEPH%
call %VCVARS% >nul
set OUT=%~dp0..\packages\jyotish_core\native
if not exist "%OUT%" mkdir "%OUT%"
set SRC=%SWEPH%\native\sweph\src
pushd "%OUT%"
cl /nologo /O2 /LD /D_CRT_SECURE_NO_WARNINGS /DMAKE_DLL /DDART_SHARED_LIB /I"%SRC%" "%SRC%\swecl.c" "%SRC%\swedate.c" "%SRC%\swehel.c" "%SRC%\swehouse.c" "%SRC%\swejpl.c" "%SRC%\swemmoon.c" "%SRC%\swemplan.c" "%SRC%\sweph.c" "%SRC%\swephlib.c" /Fe:sweph.dll
del *.obj *.exp *.lib 2>nul
popd
