ExternalProject_Add(SteSlicerBinaryData
    GIT_REPOSITORY https://gitlab.com/stereotech/steslicer/steslicer-binary-data
    GIT_TAG origin/${STESLICERBINARYDATA_BRANCH_OR_TAG}
    GIT_SHALLOW 1
    STEP_TARGETS update
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTERNALPROJECT_INSTALL_PREFIX}
)

SetProjectDependencies(TARGET SteSlicerBinaryData DEPENDS SteSlicer)

add_dependencies(update SteSlicerBinaryData-update)