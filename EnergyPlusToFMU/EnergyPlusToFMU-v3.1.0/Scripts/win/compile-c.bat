@ECHO OFF


::--- Purpose.
::
::   Compile the source code file named as a command-line argument.
:: ** Use Microsoft Visual Studio 10/C.
:: ** Native address size.


::--- Set up command environment.
::
::   Run batch file {vcvarsall.bat} if necessary.
::   Work through a hierarchy of possible directory locations.
::
IF "%DevEnvDir%"=="" (
  CALL "D:\VS\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsx86_amd64.bat"  >nul 2>&1
  IF ERRORLEVEL 1 (
    CALL "D:\VS\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsx86_amd64.bat"  >nul 2>&1
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
::   Note if the C system library implements memmove(), then #define HAVE_MEMMOVE.
:: This is necessary for compiling Expat.
::
cl /c /nologo /O2 /TC  /DHAVE_MEMMOVE  %1
IF ERRORLEVEL 1 (
  ECHO Failed to compile %1
  GOTO done
  )


:done
