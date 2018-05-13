@echo off
set xv_path=C:\\xilinx\\Vivado\\2017.1\\bin
call %xv_path%/xsim main_testbench_behav -key {Behavioral:sim:Functional:main_testbench} -tclbatch main_testbench.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
