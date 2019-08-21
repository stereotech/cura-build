set(extra_cmake_args "")
if(BUILD_OS_WINDOWS)
    set(extra_cmake_args -DArcus_DIR=${CMAKE_PREFIX_PATH}/lib-mingw/cmake/Arcus)
elseif (BUILD_OS_OSX)
    if (CMAKE_OSX_DEPLOYMENT_TARGET)
        list(APPEND extra_cmake_args
            -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
    endif()
    if (CMAKE_OSX_SYSROOT)
        list(APPEND extra_cmake_args
            -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT})
    endif()
endif()

if(BUILD_OS_OSX AND CURAENGINE_OSX_USE_GCC)
    ExternalProject_Add(CuraEngine
        GIT_REPOSITORY https://github.com/ultimaker/CuraEngine
        GIT_TAG origin/${CURAENGINE_BRANCH_OR_TAG}
        GIT_SHALLOW 1
        CONFIGURE_COMMAND DYLD_LIBRARY_PATH="$ENV{environment_dir_gcc}/lib:$ENV{DYLD_LIBRARY_PATH}"
                ${CMAKE_COMMAND}
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                   -DCMAKE_INSTALL_PREFIX=${EXTERNALPROJECT_INSTALL_PREFIX}
                   -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}/gcc
                   -DCMAKE_C_COMPILER=${OSX_GCC_C_COMPILER}
                   -DCMAKE_CXX_COMPILER=${OSX_GCC_CXX_COMPILER}
                   -DCMAKE_AR=${OSX_GCC_AR}
                   -DCMAKE_NM=${OSX_GCC_NM}
                   -DCMAKE_RANLIB=${OSX_GCC_RANLIB}
                   -DCURA_ENGINE_VERSION=${CURA_VERSION}
                   -DCMAKE_OSX_SYSROOT="${CMAKE_PREFIX_PATH}"
                   -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
                   -DENABLE_MORE_COMPILER_OPTIMIZATION_FLAGS=${CURAENGINE_ENABLE_MORE_COMPILER_OPTIMIZATION_FLAGS}
                   -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
                   -DBUILD_TESTS=OFF
                   -G "Unix Makefiles" ../CuraEngine
        BUILD_COMMAND DYLD_LIBRARY_PATH="$ENV{environment_dir_gcc}/lib:$ENV{DYLD_LIBRARY_PATH}" make
        INSTALL_COMMAND make install
    )
else()
    ExternalProject_Add(CuraEngine
        GIT_REPOSITORY https://github.com/ultimaker/CuraEngine
        GIT_TAG origin/${CURAENGINE_BRANCH_OR_TAG}
        GIT_SHALLOW 1
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                   -DCMAKE_INSTALL_PREFIX=${EXTERNALPROJECT_INSTALL_PREFIX}
                   -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
                   -DCURA_ENGINE_VERSION=${CURA_VERSION}
                   -DENABLE_MORE_COMPILER_OPTIMIZATION_FLAGS=${CURAENGINE_ENABLE_MORE_COMPILER_OPTIMIZATION_FLAGS}
                   -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
                   ${extra_cmake_args}
                   -G ${CMAKE_GENERATOR}
    )
endif()

SetProjectDependencies(TARGET CuraEngine)
