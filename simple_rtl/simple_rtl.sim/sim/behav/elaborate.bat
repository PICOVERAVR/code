@echo off
set xv_path=C:\\xilinx\\Vivado\\2017.1\\bin
call %xv_path%/xelab  -wto 6d14b457181f42608dfba18440b97c40 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot main_testbench_behav xil_defaultlib.main_testbench xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
