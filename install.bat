@echo off

if "%~1" == "" (
    echo Usage: %0 [torch distro path]
    echo.
    echo e.g.  %0 C:\torch
    echo.
    exit /B 1
)

set torch=%~f1

for /f "tokens=2 delims= " %%a in (".%torch:"=%.") do (
    echo Space detected in destination path, please change.
    exit /B 1
)
rem switch to the destination drive
%torch:~0,2%


if not exist "%torch%" (
    echo.
    echo -------------- Cloning torch --------------
    git clone https://github.com/torch/distro.git "%torch%" --recursive
)



if not exist "%torch%\install\luajit.exe" (
    echo.
    echo -------------- Installing Lua core stack --------------

    rem patch luarocks for nmake generator
    cd "%torch%\exe\luajit-rocks\luarocks"
    git apply "%~dp0\luarocks.patch"

    mkdir "%torch%\build"
    cd "%torch%\build"
    cmake "%torch%" -DCMAKE_INSTALL_PREFIX="%torch%\install" -DCMAKE_BUILD_TYPE=Release -DWITH_LUAJIT21=ON -G "NMake Makefiles"
    nmake install
    if not exist "%torch%\install\luajit.exe" exit /b 1
)



echo.
echo -------------- Installing common Lua packages --------------

echo.
echo ================= Install package: luafilesystem ==================
call "%~dp0\install_package.bat" "%torch%" "lfs.dll" "extra\luafilesystem" "rockspecs\luafilesystem-1.6.3-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: penlight ==================
call "%~dp0\install_package.bat" "%torch%" "lua\pl" "extra\penlight"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: lua-cjson ==================
call "%~dp0\install_package.bat" "%torch%" "cjson.dll" "extra\lua-cjson"
if errorlevel 1 exit /b 1



echo.
echo -------------- Installing core Torch packages --------------

echo.
echo ================= Install package: luaffifb ==================
call "%~dp0\install_package.bat" "%torch%" "ffi.dll" "extra\luaffifb"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: sundown ==================
call "%~dp0\install_package.bat" "%torch%" "libsundown.dll" "pkg\sundown" "rocks\sundown-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: cwrap ==================
call "%~dp0\install_package.bat" "%torch%" "lua\cwrap" "pkg\cwrap" "rocks\cwrap-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: paths ==================
call "%~dp0\install_package.bat" "%torch%" "libpaths.dll" "pkg\paths" "rocks\paths-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: torch ==================
call "%~dp0\install_package.bat" "%torch%" "libtorch.dll" "pkg\torch" "rocks\torch-scm-1.rockspec
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: dok ==================
call "%~dp0\install_package.bat" "%torch%" "lua\dok" "pkg\dok" "rocks\dok-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: trepl ==================
call "%~dp0\install_package.bat" "%torch%" "treplutils.dll" "exe\trepl"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: sys ==================
call "%~dp0\install_package.bat" "%torch%" "libsys.dll" "pkg\sys" "sys-1.1-0.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: xlua ==================
call "%~dp0\install_package.bat" "%torch%" "lua\xlua" "pkg\xlua" "xlua-1.0-0.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: nn ==================
call "%~dp0\install_package.bat" "%torch%" "libTHNN.dll" "extra\nn" "rocks\nn-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: graph ==================
call "%~dp0\install_package.bat" "%torch%" "lua\graph" "extra\graph" "rocks\graph-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: nngraph ==================
call "%~dp0\install_package.bat" "%torch%" "lua\nngraph" "extra\nngraph"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: image ==================
call "%~dp0\install_package.bat" "%torch%" "libimage.dll" "pkg\image"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: optim ==================
call "%~dp0\install_package.bat" "%torch%" "lua\optim" "pkg\optim" "optim-1.0.5-0.rockspec"
if errorlevel 1 exit /b 1



echo.
echo -------------- Installing CUDA packages --------------

echo.
echo ================= Install package: cutorch ==================
call "%~dp0\install_package.bat" "%torch%" "libcutorch.dll" "extra\cutorch" "rocks\cutorch-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: cunn ==================
call "%~dp0\install_package.bat" "%torch%" "libTHCUNN.dll" "extra\cunn" "rocks\cunn-scm-1.rockspec"
if errorlevel 1 exit /b 1


echo.
echo -------------- Installing optional Torch packages --------------

echo.
echo ================= Install package: gnuplot ==================
call "%~dp0\install_package.bat" "%torch%" "lua\gnuplot" "pkg\gnuplot" "rocks\gnuplot-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: env ==================
call "%~dp0\install_package.bat" "%torch%" "lua\env" "exe\env"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: nnx ==================
call "%~dp0\install_package.bat" "%torch%" "libnnx.dll" "extra\nnx"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: qtlua ==================
rem call "%~dp0\install_package.bat" "%torch%" "" "exe\qtlua" "rocks\qtlua-scm-1.rockspec"
rem if errorlevel 1 exit /b 1

echo.
echo ================= Install package: qttorch ==================
rem call "%~dp0\install_package.bat" "%torch%" "" "pkg\qttorch" "rocks\qttorch-scm-1.rockspec"
rem if errorlevel 1 exit /b 1

echo.
echo ================= Install package: threads ==================
call "%~dp0\install_package.bat" "%torch%" "libthreads.dll" "extra\threads" "rocks\threads-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: graphicsmagick ==================
call "%~dp0\install_package.bat" "%torch%" "lua\graphicsmagick" "extra\graphicsmagick"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: argcheck ==================
call "%~dp0\install_package.bat" "%torch%" "lua\argcheck" "extra\argcheck" "rocks\argcheck-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: fftw3 ==================
call "%~dp0\install_package.bat" "%torch%" "lua\fftw3" "extra\fftw3" "rocks\fftw3-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: audio ==================
rem call "%~dp0\install_package.bat" "%torch%" "audio" "extra\audio"
rem if errorlevel 1 exit /b 1

echo.
echo ================= Install package: signal ==================
call "%~dp0\install_package.bat" "%torch%" "libsignal.dll" "extra\signal" "rocks\signal-scm-1.rockspec"
if errorlevel 1 exit /b 1



echo.
echo -------------- Installing optional CUDA packages --------------

echo.
echo ================= Install package: cudnn ==================
call "%~dp0\install_package.bat" "%torch%" "lua\cudnn" "extra\cudnn"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: cunnx ==================
call "%~dp0\install_package.bat" "%torch%" "libcunnx.dll" "extra\cunnx" "rocks\cunnx-scm-1.rockspec"
if errorlevel 1 exit /b 1



echo.
echo -------------- Installing additional packages --------------
mkdir "%torch%\additional"

echo.
echo ================= Install package: luasocket ==================
call "%~dp0\install_package.bat" "%torch%" "socket\core.dll" "additional\luasocket" "luasocket-scm-0.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: torchx ==================
call "%~dp0\install_package.bat" "%torch%" "lua\torchx" "additional\torchx" "torchx-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: moses ==================
call "%~dp0\install_package.bat" "%torch%" "luarocks\moses" "additional\moses" "rockspec\moses-1.4.0-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: dpnn ==================
call "%~dp0\install_package.bat" "%torch%" "luarocks\dpnn" "additional\dpnn" "rocks\dpnn-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: rnn ==================
call "%~dp0\install_package.bat" "%torch%" "lua\rnn" "additional\rnn" "rocks\rnn-scm-1.rockspec"
if errorlevel 1 exit /b 1

echo.
echo ================= Install package: dp ==================
call "%~dp0\install_package.bat" "%torch%" "luarocks\dp" "additional\dp" "rocks\dp-scm-1.rockspec"
if errorlevel 1 exit /b 1



echo.
echo.
echo.
echo -------------- Install complete. --------------
echo   Torch installed @ %torch%\install
echo -----------------------------------------------
echo.

