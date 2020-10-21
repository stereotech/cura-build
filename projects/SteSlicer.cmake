option(STESLICER_ENABLE_DEBUGMODE "Enable crash handler and other debug options in STE Slicer" OFF)

# WORKAROUND: CMAKE_ARGS itself is a string list with items separated by ';'. Passing a string list that's also
# separated by ';' as an argument via CMAKE_ARGS will make it confused. Converting it to "," and then to ";" is a
# workaround.
string(REPLACE ";" "," _steslicer_no_install_plugins "${STESLICER_NO_INSTALL_PLUGINS}")

ExternalProject_Add(SteSlicer
    GIT_REPOSITORY https://github.com/stereotech/STE-Slicer
    GIT_TAG origin/${STESLICER_BRANCH_OR_TAG}
    GIT_SHALLOW 1
    STEP_TARGETS update
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTERNALPROJECT_INSTALL_PREFIX}
               -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
               -DURANIUM_SCRIPTS_DIR=
               -DSTESLICER_VERSION=${STESLICER_VERSION}
               -DSTESLICER_BUILDTYPE=${STESLICER_BUILDTYPE}
               -DSTESLICER_DEBUGMODE=${STESLICER_ENABLE_DEBUGMODE}
               -DSTESLICER_NO_INSTALL_PLUGINS=${_steslicer_no_install_plugins}
)

# SetProjectDependencies(TARGET SteSlicer DEPENDS Uranium CuraEngine)
SetProjectDependencies(TARGET SteSlicer DEPENDS Uranium)

add_dependencies(update SteSlicer-update)
