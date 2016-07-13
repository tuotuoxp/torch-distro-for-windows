# torch-distro-for-windows
Patches for people who want to install torch on windows


Requirements
============

* cmake for windows
* git for windows
* Microsoft Visual Studio 2013 (community / professional)
* [optional] NVIDIA CUDA SDK

Usage
=====

* Open VS2013 x64 Native Tools Command Prompt
* Run following commands
``` sh
git config --global core.autocrlf false
git clone https://github.com/tuotuoxp/torch-distro-for-windows.git torch-win
git config --global core.autocrlf true
torch-win\install.bat c:\torch
```
