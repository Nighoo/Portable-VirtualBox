@echo off       
rem User-defined variables. You may have to change its values to correspond to your system and remove the "rem" statement in front of it.
rem set "aut2exe=D:\Programs\AutoIt\Aut2Exe\aut2exe.exe"
rem set "sevenzip=C:\Program Files\7-Zip\7z.exe"
rem set "reshack=D:\Programs\reshack\reshacker.exe"
rem End of user-defined variables.



rem Setting up the different folders used for building. %~dp0 is the folder of the build script itself (may not be the same as the working directory).
set "input_folder=%~dp0"
set "build_folder=%input_folder%\build\source"
set "release_folder=%input_folder%\build\release"
set "output_name=Portable-VirtualBox_current.exe"



rem Try to find the aut2exe path.
set "PROG=AutoIt3\Aut2Exe\aut2exe.exe"

set PPATH="%ProgramFiles%\%PROG%"
set PPATHx86="%ProgramFiles(x86)%\%PROG%"
IF exist %PPATH% (
    set aut2exe=%PPATH%
) ELSE (
    set aut2exe=%PPATHx86%
)

IF not exist %aut2exe% (
    echo Can't locate AutoIt. Is it installed? Pleas set the aut2exe variable if it is installed in a nonstandard path.
    EXIT /B
)



rem Try to find the sevenzip path.
set "PROG=7-Zip\7z.exe"

set PPATH="%ProgramFiles%\%PROG%"
set PPATHx86="%ProgramFiles(x86)%\%PROG%"
IF exist %PPATH% (
    set sevenzip=%PPATH%
) ELSE (
    set sevenzip=%PPATHx86%
)

IF not exist %sevenzip% (
    echo Can't locate 7-Zip. Is it installed? Pleas set the sevenzip variable if it is installed in a nonstandard path.
    EXIT /B
)



rem Try to find the reshack path.
set "PROG=Resource Hacker\reshacker.exe"

set PPATH="%ProgramFiles%\%PROG%"
set PPATHx86="%ProgramFiles(x86)%\%PROG%"
IF exist %PPATH% (
    set reshack=%PPATH%
) ELSE (
    set reshack=%PPATHx86%
)

IF not exist %reshack% (
    echo Can't locate Reshack. Is it installed? Pleas set the reshack variable if it is installed in a nonstandard path.
    EXIT /B
)



echo aut2exe path: %aut2exe%
echo sevenzip path: %sevenzip%
echo reshack path: %reshack%

rem Remove any old files in the build directory.
rmdir /s /q %build_folder%\Portable-VirtualBox

rem Create build and release folders if needed.
if not exist "%build_folder%\Portable-VirtualBox" md "%build_folder%\Portable-VirtualBox"
if not exist "%release_folder%" md "%release_folder%"

rem Make a copy of the file for easy compression later.
xcopy /i /e "%input_folder%data" "%build_folder%\Portable-VirtualBox\data\"
xcopy /i /e "%input_folder%source" "%build_folder%\Portable-VirtualBox\source\"
xcopy "%input_folder%LiesMich.txt" "%build_folder%\Portable-VirtualBox\"
xcopy "%input_folder%ReadMe.txt"  "%build_folder%\Portable-VirtualBox\"

rem Compile Portable-VirtualBox.
%aut2exe% /in "%build_folder%\Portable-VirtualBox\source\Portable-VirtualBox.au3" /out "%build_folder%\Portable-VirtualBox\Portable-VirtualBox.exe" /icon "%build_folder%\Portable-VirtualBox\source\VirtualBox.ico" /x86

rem Make a release by packing the exe, data and source code into a self-extracting archive.
pushd %build_folder%
%sevenzip% a -r -x!.git -sfx7z.sfx "%release_folder%\Portable-VirtualBox.tmp" "Portable-VirtualBox"
popd

rem Change the icon on the self-extracting archive.
%reshack% -addoverwrite "%release_folder%\Portable-VirtualBox.tmp", "%release_folder%\%output_name%", "%build_folder%\Portable-VirtualBox\source\VirtualBox.ico",ICONGROUP,1,1033

del /q "%release_folder%\Portable-VirtualBox.tmp"

echo ###############################################################################
echo Build new release as %release_folder%\%output_name%
echo ###############################################################################

pause