rem This is the build script that should be executed in the Windows docker container
rem to build a STE Slicer release.

@echo OFF

echo ========== Build Variables BEGIN ==========
echo STESLICER_BUILD_ENV_PATH    = "%CURA_BUILD_ENV_PATH%"
echo STESLICER_BUILD_SRC_PATH    = "%STESLICER_BUILD_SRC_PATH%"
echo STESLICER_BUILD_OUTPUT_PATH = "%STESLICER_BUILD_OUTPUT_PATH%"
echo
echo STESLICER_BRANCH_OR_TAG      = "%STESLICER_BRANCH_OR_TAG%"
echo URANIUM_BRANCH_OR_TAG        = "%URANIUM_BRANCH_OR_TAG%"
echo CURAENGINE_BRANCH_OR_TAG     = "%CURAENGINE_BRANCH_OR_TAG%"
echo CURABINARYDATA_BRANCH_OR_TAG = "%CURABINARYDATA_BRANCH_OR_TAG%"
echo FDMMATERIALS_BRANCH_OR_TAG   = "%FDMMATERIALS_BRANCH_OR_TAG%"
echo
echo STESLICER_VERSION_MAJOR = "%STESLICER_VERSION_MAJOR%"
echo STESLICER_VERSION_MINOR = "%STESLICER_VERSION_MINOR%"
echo STESLICER_VERSION_PATCH = "%STESLICER_VERSION_PATCH%"
echo STESLICER_VERSION_EXTRA = "%STESLICER_VERSION_EXTRA%"
echo
echo STESLICER_BUILD_NAME = "%STESLICER_BUILD_NAME%"
echo
echo CPACK_GENERATOR = "%CPACK_GENERATOR%"
echo ========== Build Variables END ==========

echo Prepare environment variables ...
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64
set PATH=C:\ProgramData\chocolatey\lib\mingw\tools\install\mingw64\bin;%PATH%
set PATH=%CURA_BUILD_ENV_PATH%\bin;%PATH%

set steslicer_build_work_dir=C:\temp\steslicer-build
echo Prepare work directory "%steslicer_build_work_dir%" ...
mkdir %steslicer_build_work_dir%
echo "Copying %STESLICER_BUILD_SRC_PATH% to %steslicer_build_work_dir%"
robocopy /e "%STESLICER_BUILD_SRC_PATH%" "%steslicer_build_work_dir%\src"
cd /d %steslicer_build_work_dir%\src

cmake -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH="%CURA_BUILD_ENV_PATH%" ^
      -DBUILD_OS_WIN64=ON ^
      -DSIGN_PACKAGE=OFF ^
      -DSTESLICER_BRANCH_OR_TAG="%STESLICER_BRANCH_OR_TAG%" ^
      -DURANIUM_BRANCH_OR_TAG="%URANIUM_BRANCH_OR_TAG%" ^
      -DCURAENGINE_BRANCH_OR_TAG="%CURAENGINE_BRANCH_OR_TAG%" ^
      -DCURABINARYDATA_BRANCH_OR_TAG="%CURABINARYDATA_BRANCH_OR_TAG%" ^
      -DFDMMATERIALS_BRANCH_OR_TAG="%FDMMATERIALS_BRANCH_OR_TAG%" ^
      -DSTESLICER_VERSION_MAJOR="%STESLICER_VERSION_MAJOR%" ^
      -DSTESLICER_VERSION_MINOR="%STESLICER_VERSION_MINOR%" ^
      -DSTESLICER_VERSION_PATCH="%STESLICER_VERSION_PATCH%" ^
      -DSTESLICER_VERSION_EXTRA="%STESLICER_VERSION_EXTRA%" ^
      -DSTESLICER_BUILD_NAME="%STESLICER_BUILD_NAME%" ^
      -DCPACK_GENERATOR="%CPACK_GENERATOR%" ^
      -G "NMake Makefiles" ^
      .
nmake
nmake package

rem Copy all build data
robocopy /e %steslicer_build_work_dir%\src %STESLICER_BUILD_OUTPUT_PATH%\build

echo Copying the installer to the mounted volume ...
copy /y "Stereotech STE Slicer*.exe" %STESLICER_BUILD_OUTPUT_PATH%\
