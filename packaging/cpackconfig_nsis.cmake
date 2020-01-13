include(CPackComponent)

include(packaging/cpackconfig_common.cmake)

# Only include Arduino driver and VC runtime redistribution installer for NSIS
cpack_add_component(vcredist DISPLAY_NAME "Install Visual Studio 2015 Redistributable")
# cpack_add_component(arduino DISPLAY_NAME "Arduino Drivers")

# ========================================
# NSIS
# ========================================
set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
set(CPACK_NSIS_EXECUTABLES_DIRECTORY ".")
set(CPACK_NSIS_INSTALLED_ICON_NAME "SteSlicer.ico")
set(CPACK_NSIS_MUI_ICON ${CMAKE_SOURCE_DIR}\\\\packaging\\\\steslicer.ico)   # note: fails with forward '/'
set(CPACK_PACKAGE_ICON ${CMAKE_SOURCE_DIR}\\\\packaging\\\\steslicer.ico)

set(CPACK_NSIS_MENU_LINKS
    "https://stereotech.org/manuals/steslicer" "Online Documentation"
    "https://gitlab.com/stereotech/steslicer/ste-slicer" "Development Resources"
)

set(CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP ${CMAKE_SOURCE_DIR}\\\\packaging\\\\steslicer_banner_nsis.bmp)    # note: fails with forward '/'
set(CPACK_NSIS_MUI_UNWELCOMEFINISHPAGE_BITMAP ${CMAKE_SOURCE_DIR}\\\\packaging\\\\steslicer_banner_nsis.bmp)
set(CPACK_NSIS_INSTALLER_MUI_FINISHPAGE_RUN_CODE "!define MUI_FINISHPAGE_RUN \\\"$WINDIR\\\\explorer.exe\\\"\n!define MUI_FINISHPAGE_RUN_PARAMETERS \\\"$INSTDIR\\\\SteSlicer.exe\\\"")	# Hack to ensure STE Slicer is not started with admin rights
