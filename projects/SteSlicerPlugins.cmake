ExternalProject_Add(SteSlicerPlugins
    GIT_REPOSITORY https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.com/https://gitlab.com/stereotech/steslicer/ste-slicer-plugins.git
    GIT_TAG origin/${STESLICERPLUGINS_BRANCH_OR_TAG}
    GIT_SHALLOW 1
    STEP_TARGETS update
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTERNALPROJECT_INSTALL_PREFIX}
)

SetProjectDependencies(TARGET SteSlicerPlugins DEPENDS SteSlicer)

add_dependencies(update SteSlicerPlugins-update)