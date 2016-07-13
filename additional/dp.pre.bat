@echo off

rem %1 - torch root
set torch=%~1


rmdir /S /Q "%torch%\additional\dp"
cd "%torch%\additional"
git clone https://github.com/nicholas-leonard/dp
