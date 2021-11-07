@ECHO OFF


::--- Purpose.
::
::   Compile the source code file named as a command-line argument.
:: ** Use Microsoft Visual Studio 10/C++.
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


::--- Check command-line arguments.
::
IF -%1-==-- (
  ECHO Error: compiler batch file requires one command-line argument
  GOTO done
  )


::--- Compile.
::
cl /c /nologo /O2 /TP /EHsc  %1
IF ERRORLEVEL 1 (
  ECHO Failed to compile %1
  GOTO done
  )


:done
