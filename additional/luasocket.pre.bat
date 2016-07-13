@echo off

rem %1 - torch root
set torch=%~1


rmdir /S /Q "%torch%\additional\luasocket"
cd "%torch%\additional"
git clone https://github.com/diegonehab/luasocket
