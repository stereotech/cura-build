cpack_add_component(_steslicer
                    DISPLAY_NAME "Stereotech STE Slicer"
                    Description "Stereotech STE Slicer Executable and Data Files"
                    REQUIRED
)

# ========================================
# CPack Common Settings
# ========================================
set(CPACK_PACKAGE_NAME "Stereotech STE Slicer")
set(CPACK_PACKAGE_VENDOR "Stereotech LLC.")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://gitlab.com/stereotech/steslicer/ste-slicer")

# MSI only supports version format like "x.x.x.x" where x is an integer from 0 to 65534
set(CPACK_PACKAGE_VERSION_MAJOR ${STESLICER_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${STESLICER_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${STESLICER_VERSION_PATCH})

set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/packaging/steslicer.ico")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Stereotech STE Slicer - 5D Printing Software")
set(CPACK_PACKAGE_CONTACT "Stereotech Dev <dev@ste3d.ru>")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/packaging/steslicer_license.txt")

set(CPACK_CREATE_DESKTOP_LINKS SteSlicer "Stereotech STE Slicer ${STESLICER_VERSION_MAJOR}.${STESLICER_VERSION_MINOR}")
set(CPACK_PACKAGE_EXECUTABLES SteSlicer "Stereotech STE Slicer ${STESLICER_VERSION_MAJOR}.${STESLICER_VERSION_MINOR}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "Stereotech STE Slicer ${STESLICER_VERSION_MAJOR}.${STESLICER_VERSION_MINOR}")
