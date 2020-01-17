set(STESLICERPLUGINS_REPO_LINK "http://${STESLICERPLUGINS_DEPLOY_USERNAME}:${STESLICERPLUGINS_DEPLOY_TOKEN}@gitlab.com/stereotech/steslicer/ste-slicer-plugins.git")
message(STATUS "Repo link: ${STESLICERPLUGINS_REPO_LINK}")

ExternalProject_Add(SteSlicerPlugins
    GIT_REPOSITORY ${STESLICERPLUGINS_REPO_LINK}
    GIT_TAG origin/${STESLICERPLUGINS_BRANCH_OR_TAG}
    GIT_SHALLOW 1
    STEP_TARGETS update
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTERNALPROJECT_INSTALL_PREFIX}
)

SetProjectDependencies(TARGET SteSlicerPlugins DEPENDS SteSlicer)

add_dependencies(update SteSlicerPlugins-update)