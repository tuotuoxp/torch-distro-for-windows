@echo off


rem %1 - torch root
rem %2 - destination file/path (ralated to %torchroot%\install)
rem %3 - package path (related to torch root)
rem %4 - [optional] rock file path (related to package path)

set torch=%~1
set dest=%~2
set package=%~3
set rock=%~4

if "%torch%" == "" goto usage
if "%dest%" == "" goto usage
if "%package%" == "" goto usage


rem check if already installed
if exist "%torch%\install\%dest%" exit /b 0


rem check if prerequisite exists
if exist "%~dp0\%package%.pre.bat" (
    call "%~dp0\%package%.pre.bat" "%torch%"
    if errorlevel 1 (
        echo [ERROR] Running prerequisite failed.
        exit /b 2
    )
)

rem check if additional bin/lib/header needed
if exist "%~dp0\%package%\include" xcopy /E /Y "%~dp0\%package%\include\*.*" "%torch%\install\include\"
if exist "%~dp0\%package%\bin"     xcopy /E /Y "%~dp0\%package%\bin\*.*"     "%torch%\install\"
if exist "%~dp0\%package%\lib"     xcopy /E /Y "%~dp0\%package%\lib\*.*"     "%torch%\install\"


cd "%torch%\%package%"


rem check if patch needed
if exist "%~dp0\%package%.patch" (
    for /F "delims=" %%l in ('git apply --numstat "%~dp0\%package%.patch"') do (
        for /F "tokens=3,4" %%f in ("%%l") do (
            rem backup files to be patched, if there is already a backup, then restore
            setlocal EnableDelayedExpansion
            set f=%%f
            set f=!f:/=\!
            if exist "%torch%\%package%\!f!.bak" (
                copy /Y "%torch%\%package%\!f!.bak" "%torch%\%package%\!f!"
            ) else (
                copy /Y "%torch%\%package%\!f!" "%torch%\%package%\!f!.bak"
            )
            endlocal
        )
    )
    rem apply patch
    git apply "%~dp0\%package%.patch"
    if errorlevel 1 (
        echo [ERROR] Applying patch failed.
        exit /b 3
    )
)


rem run luarocks
if "%rock%" == "" (
    call "%torch%\install\luarocks" make
) else (
    call "%torch%\install\luarocks" make "%rock%"
)
if errorlevel 1 exit /b 1


rem check if destination file/path exists
if exist "%torch%\install\%dest%" (
    exit /b 0
) else (
    exit /b 1
)



:usage
echo.
echo Usage: %0 torch_root package_destination_file/path package_source_path [rock_file_path]
echo.
echo         torch_root                    - the root of torch distro git
echo         package_destination_file/path - related to torch_root\install
echo         package_source_path           - related to torch_root
echo         rock_file_path                - related to package_source_path
echo.
exit /b 1

