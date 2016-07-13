@echo off

rem %1 - torch root
set torch=%~1


rmdir /S /Q "%torch%\additional\dpnn"
cd "%torch%\additional"
git clone https://github.com/Element-Research/dpnn
