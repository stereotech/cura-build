ExternalProject_Add(cura-binary-data
    GIT_REPOSITORY https://github.com/ultimaker/cura-binary-data
    GIT_TAG ${CURABINARYDATA_BRANCH_OR_TAG}
    GIT_SHALLOW 1
    STEP_TARGETS update
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTERNALPROJECT_INSTALL_PREFIX}
)

SetProjectDependencies(TARGET cura-binary-data DEPENDS SteSlicer)

add_dependencies(update cura-binary-data-update)
