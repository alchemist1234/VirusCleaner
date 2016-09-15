@echo off
color f3
title VirusCleaner    by zhanchen
set pathError=false

:Start
echo.
echo  ****************************************************************
echo  * 该脚本可以将被隐藏的文件恢复显示,并清除伪装成正常文件的U盘病毒
echo  * (该脚本不会作用于子文件夹，如果U盘所有文件被病毒移入某文件夹下，
echo  * 请输入该文件夹路径)
echo  *
echo  * 注1：该脚本会在当前目录创建一个temp.dat文件，正常结束后删除
echo  * 注2：出现“找不到文件”属正常现象
echo  * 注3：该脚本会将去除所有文件的隐藏及系统属性
echo  * 注4：该脚本会删除autorun.inf文件
echo  *
echo  * 作者：zhanchen                                      2016.07.07
echo  ****************************************************************
echo.

if %pathError%==true (
  echo 输入路径%disk%不存在，请重新输入
  set disk=
  echo.
)
echo 请输入U盘盘符或文件夹路径(如C:或C:\folder)，
set /p disk=直接按回车为当前路径：
echo.

if "%disk%"=="" set disk=%~dp0

if not exist %disk% (
  cls
  set pathError=true
  goto Start
)

for %%i in (%disk%\*.lnk %disk%\*.exe) do (
  echo %%~nxi>>temp.dat
)
if not exist temp.dat (
  goto L1
)

for /f "delims=" %%j in ('dir /ah/b "%disk%"') do (
  attrib -s -h -a -r %disk%\%%~nxj>nul
)

for /f "delims=/" %%i in (temp.dat) do (
  for /f "delims=" %%j in ('dir /b "%disk%"') do (
    if %%~nxj==%%~ni del %disk%\%%i /s/q/f
  )
)

:L1

if exist %disk%\autorun.inf del autorun.inf /s/q/f >nul

if exist %disk%\疑似病毒文件列表.txt del %disk%\疑似病毒文件列表.txt /f/s/q>nul

for %%i in (%disk%\*.lnk %disk%\*.exe %disk%\*.vbs %disk%\*.cmd %disk%\*.bat) do (
  if %%~nxi neq %~nx0 echo %%~nxi>>%disk%\疑似病毒文件列表.txt
)

if exist %disk%\疑似病毒文件列表.txt (
  echo.
  echo 部分文件无法判断是否为病毒
  echo 其文件名已被写入%disk%下“疑似病毒文件列表.txt”中
  echo 请自行判断并将病毒文件删除
)

if not exist temp.dat (if not exist 疑似病毒文件列表.txt echo 未发现病毒)

:End
if exist temp.dat del temp.dat /f/q >nul
echo.
echo 程序运行结束，按任意键退出...
pause>nul