@echo off

rem %1 - torch root
set torch=%~1


rem threads - dlfcn
if not exist "%torch%\install\dl.dll" (
    cd "%torch%\extra\threads"
    rmdir /S /Q "%torch%\extra\threads\dlfcn-win32"
    git clone https://github.com/dlfcn-win32/dlfcn-win32.git
    mkdir "%torch%\extra\threads\dlfcn-win32\build"
    cd "%torch%\extra\threads\dlfcn-win32\build"
    cmake .. -DCMAKE_INSTALL_PREFIX="%torch%\extra\threads\dlfcn-win32\install" -G "NMake Makefiles"
    nmake install
    if not exist "%torch%\extra\threads\dlfcn-win32\install\bin\dl.dll" exit /b 1

    copy /Y "%torch%\extra\threads\dlfcn-win32\install\include\*.*" "%torch%\install\include\"
    copy /Y "%torch%\extra\threads\dlfcn-win32\install\lib\*.lib" "%torch%\install\"
    copy /Y "%torch%\extra\threads\dlfcn-win32\install\bin\*.dll" "%torch%\install\"
)
