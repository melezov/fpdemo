@echo off
setlocal
pushd "%~dp0"

:: Get time and date without independent of locale
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set SNAPSHOT=%ldt:~0,8%-%ldt:~8,6%
set HEAD_PACKAGE=fpdemo
set PACKAGE=%HEAD_PACKAGE%

set MODEL_JAR=fpdemo-model-%SNAPSHOT%.jar
set MODEL_SRC=fpdemo-model-%SNAPSHOT%-sources.jar

:: Cache compiler download
set COMPILER_DOWNLOADED=
if exist temp\compile\dsl-compiler.exe (
  move temp\compile\dsl-compiler.exe temp\dsl-compiler.exe > NUL
  set COMPILER_DOWNLOADED==temp\dsl-compiler.exe
)

:: Remove old compilation results
echo Cleaning old compilation ...
if exist temp\output\*.jar del temp\output\*.jar
if not exist temp\output mkdir temp\output

if exist temp\compile rmdir /S /Q temp\compile
mkdir temp\compile

if exist temp\source\revenj.java rmdir /S /Q temp\source\revenj.java
mkdir temp\source\revenj.java

:: Create model jar, apply migration
echo Compiling model to temp\output\%MODEL_JAR% ...
java -jar dsl-clc.jar ^
  dsl=dsl ^
  temp=temp\compile ^
  compiler%COMPILER_DOWNLOADED% ^
  download ^
  namespace=%PACKAGE% ^
  sql=sql ^
  dependencies:revenj.java=temp\dependencies\revenj.java ^
  revenj.java=temp\output\%MODEL_JAR% ^
  migration ^
  "postgres=fpdemo-postgres:5432/fpdb?user=fpuser&password=fppass" ^
  apply
IF ERRORLEVEL 1 goto :error

:: Copy sources so that we can archive them
move temp\compile\REVENJ_JAVA\%HEAD_PACKAGE% temp\source\revenj.java > NUL

:: Format SQL script and Java sources
:: This also "fixes" the paths in database_migration scripts
echo Running code formatter ...
java -jar dsl-clc-formatter-0.2.1.jar ^
  sql ^
  temp\source
IF ERRORLEVEL 1 goto :error

:: Creates the source package
echo Archiving sources to temp\output\%MODEL_SRC% ...
jar cfM temp\output\%MODEL_SRC% -C temp\source\revenj.java\ .
IF ERRORLEVEL 1 goto :error

:: Try to clean old libraries, copy output to lib
echo Deploying new model to lib folder ...
call :deploy temp\output\%MODEL_JAR% ..\code\lib\fpdemo-model.jar
call :deploy temp\output\%MODEL_SRC% ..\code\lib\fpdemo-model-sources.jar

:done
popd
goto :EOF

:error
echo An error has occurred, aborting compilation!
goto :done

:deploy
if exist %2 del %2
if exist %2 (
  echo WARNING: Could not remove %2 - is it being used?
  echo Press enter to try again!
  pause
  if exist %2 del %2
  if exist %2 (
    echo ERROR: You should deploy %1 manually!
    echo ERROR: Could not remove %2 - it is still being used!
    goto :EOF
  )
)
copy %1 %2 > NUL
goto :EOF
