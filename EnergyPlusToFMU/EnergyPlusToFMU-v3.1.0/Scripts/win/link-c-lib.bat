@ECHO OFF


::--- Purpose.
::
::   Link the object file(s) named as command-line arguments.
:: ** Make a DLL.
:: ** Use Microsoft Visual Studio 10/C.
:: ** Native address size.


::--- Set up command environment.
::
::   Run batch file {vcvarsall.bat} if necessary.
::   Work through a hierarchy of possible directory locations.
::
IF "%DevEnvDir%"=="" (
  CALL "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\x86_amd64\vcvarsx86_amd64.bat"  >nul 2>&1
  IF ERRORLEVEL 1 (
    CALL "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\x86_amd64\vcvarsx86_amd64.bat"  >nul 2>&1
    IF ERRORLEVEL 1 (
      ECHO Problem configuring the Visual Studio tools for command-line use
      GOTO done
      )
    )
  )


::--- Get command-line argument giving {outputName}.
::
IF -%1-==-- (
  ECHO Error: linker batch file requires first command-line argument naming output executable
  GOTO done
  )
::
SET outputName=%1
:: ECHO outputName is %outputName%
::
:: Shift {outputName} off, so remaining arguments start at %1.
SHIFT


::--- Get command-line arguments giving object file names.
::
IF -%1-==-- (
  ECHO Error: linker batch file requires command-line arguments listing object files
  GOTO done
  )
::
:: Here, have at least one object file.  Start {objList} with it.
SET objList=%1
::
:: Here, assume have just added %1 to {objList}.
:addNextObjFile
SHIFT
IF -%1-==-- (
  GOTO noMoreObjFiles
  )
SET objList=%objList% %1
GOTO :addNextObjFile
::
:noMoreObjFiles
:: ECHO objList is %objList%


::--- Link.
::
cl /nologo /LD /Fe%outputName%  %objList%
IF ERRORLEVEL 1 (
  ECHO Failed to link "%outputName%"
  GOTO done
  )


:done
