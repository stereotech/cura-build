project(steslicer-build)

cmake_minimum_required(VERSION 3.6)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

option(BUILD_OFFLINE "Build offline (use target 'update' to update sources)." OFF)

if(BUILD_OFFLINE)
    set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED 1)
endif()

include(ExternalProject)
include(GNUInstallDirs)

include(BuildPlatformDetection)
include(GetFromEnvironmentOrCache)
include(SetProjectDependencies)

option(BUILD_PACKAGE "Create a package with the build of STE Slicer" ON)
option(SIGN_PACKAGE "Perform signing of the created package. Implies BUILD_PACKAGE" ON)

set(STESLICER_BUILDTYPE          "" CACHE STRING "Build type of STE Slicer, eg. 'testing'")
set(STESLICER_NO_INSTALL_PLUGINS "" CACHE STRING "A list of plugins to exclude from installation, should be separated by ';'.")
set(STESLICER_MSI_PRODUCT_GUID   "" CACHE STRING "The Product GUID for STE Slicer MSI")
set(STESLICER_MSI_UPGRADE_GUID   "" CACHE STRING "The Upgrade GUID for STE Slicer MSI")

# STE Slicer MSI product GUID and upgrade GUID
if(BUILD_PACKAGE)
    if(NOT DEFINED STESLICER_MSI_PRODUCT_GUID)
        message(STATUS "STESLICER_MSI_PRODUCT_GUID must be provided.")
    endif()
    if(NOT DEFINED STESLICER_MSI_UPGRADE_GUID)
        message(STATUS "STESLICER_MSI_UPGRADE_GUID must be provided.")
    endif()
endif()

if(SIGN_PACKAGE)
    set(BUILD_PACKAGE ON)
endif()

set(EXTERNALPROJECT_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/inst)

GetFromEnvironmentOrCache(FDMMATERIALS_BRANCH_OR_TAG "master" STRING "The name of the tag or branch to build for fdm_materials")
GetFromEnvironmentOrCache(STESLICERBINARYDATA_BRANCH_OR_TAG "master" STRING "The name of the tag or branch to build for SteSlicerBinaryData")
GetFromEnvironmentOrCache(CURAENGINE_BRANCH_OR_TAG "master" STRING "The name of the tag or branch to build for CuraEngine")
GetFromEnvironmentOrCache(URANIUM_BRANCH_OR_TAG "master" STRING "The name of the tag or branch to build for Uranium")
GetFromEnvironmentOrCache(STESLICER_BRANCH_OR_TAG "master" STRING "The name of the tag or branch to build for STE Slicer")
GetFromEnvironmentOrCache(LIBCHARON_BRANCH_OR_TAG "master" STRING "The name of the tag or branch to build for libCharon")

GetFromEnvironmentOrCache(CURAENGINE_ENABLE_MORE_COMPILER_OPTIMIZATION_FLAGS "ON" STRING "Whether to enable extra compiler optimization flags for CuraEngine")

GetFromEnvironmentOrCache(EXTRA_REPOSITORIES "" STRING "Extra repositories to install. Expected to have a CMake based build system. Format is (<project name> <git URL> <cmake configuration options>\;)*")

# Create the version-related variables
GetFromEnvironmentOrCache(STESLICER_VERSION_MAJOR "0" STRING "STE Slicer Major Version")
GetFromEnvironmentOrCache(STESLICER_VERSION_MINOR "0" STRING "STE Slicer Minor Version")
GetFromEnvironmentOrCache(STESLICER_VERSION_PATCH "0" STRING "STE Slicer Patch Version")
GetFromEnvironmentOrCache(STESLICER_VERSION_EXTRA "${TAG_OR_BRANCH}" STRING "STE Slicer Extra Version Information")

GetFromEnvironmentOrCache(STESLICER_EXTRA_PROJECTS_DIR "" STRING "Directory where extra projects to build are located.")

set(STESLICER_VERSION "${STESLICER_VERSION_MAJOR}.${STESLICER_VERSION_MINOR}.${STESLICER_VERSION_PATCH}")
if(NOT "${STESLICER_VERSION_EXTRA}" STREQUAL "")
    set(STESLICER_VERSION "${STESLICER_VERSION}-${STESLICER_VERSION_EXTRA}")
endif()

# Build projects step
add_custom_target(projects ALL COMMENT "Building Projects...")

file(GLOB _projects projects/*.cmake)
if(NOT STESLICER_EXTRA_PROJECTS_DIR STREQUAL "")
    file(GLOB _extra_projects ${STESLICER_EXTRA_PROJECTS_DIR}/*.cmake)
    list(APPEND _projects ${_extra_projects})
endif()

add_custom_target(update COMMENT "Updating Projects...")

foreach(_project ${_projects})
    # Go through all files in projects/ and include them. The project files should define
    # targets for the actual projects. In addition, these files are expected to define any
    # packages they depend on with find_package and any other projects they depend on as
    # dependencies of the target(s). Project files are free to define multiple targets though
    # they should only define targets relevant for that project.
    include(${_project})
endforeach()


ProcessProjectDependencies(TARGET projects)

# Create package step
if(BUILD_PACKAGE)
    add_custom_target(packaging ALL DEPENDS projects COMMENT "Packaging Projects...")

    if(BUILD_OS_WINDOWS)
        include(packaging/windows.cmake)
    else()
        message(STATUS "Do not know how to build an executable for the current platform! You will have to create it manually.")
    endif()
endif()

# Sign packages step
if(SIGN_PACKAGE)
    add_custom_target(signing ALL DEPENDS packaging COMMENT "Signing Package...")

    if(BUILD_OS_WINDOWS)
        include(signing/windows.cmake)
    else()
        message(STATUS "Do not know how to sign the executable for the current platform! You will need to perform signing manually.")
    endif()
endif()
