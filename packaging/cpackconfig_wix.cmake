include(CPackComponent)

include(packaging/cpackconfig_common.cmake)

# ========================================
# MSI
# ========================================
set(CPACK_WIX_CULTURES "en-US")
set(CPACK_WIX_PRODUCT_GUID "${STESLICER_MSI_PRODUCT_GUID}")
set(CPACK_WIX_UPGRADE_GUID "${STESLICER_MSI_UPGRADE_GUID}")
set(CPACK_WIX_PRODUCT_ICON "${CMAKE_SOURCE_DIR}/packaging/steslicer.ico")
set(CPACK_WIX_UI_BANNER "${CMAKE_SOURCE_DIR}/packaging/steslicer_banner_msi.bmp")
set(CPACK_WIX_UI_DIALOG "${CMAKE_SOURCE_DIR}/packaging/steslicer_background_msi.bmp")
set(CPACK_WIX_PROGRAM_MENU_FOLDER "Stereotech STE Slicer")

set(CPACK_WIX_TEMPLATE "${CMAKE_SOURCE_DIR}/packaging/steslicer.wxs")
