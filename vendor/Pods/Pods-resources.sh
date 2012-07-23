#!/bin/sh

install_resource()
{
  case $1 in
    *.xib)
      echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xib`.nib ${SRCROOT}/Pods/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xib`.nib ${SRCROOT}/Pods/$1 --sdk ${SDKROOT}
      ;;
    *)
      echo "cp -R ${SRCROOT}/Pods/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      cp -R "${SRCROOT}/Pods/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      ;;
  esac
}
install_resource 'Kal/src/Kal.bundle/kal_grid_background.png'
install_resource 'Kal/src/Kal.bundle/kal_grid_shadow.png'
install_resource 'Kal/src/Kal.bundle/kal_header_text_fill.png'
install_resource 'Kal/src/Kal.bundle/kal_left_arrow.png'
install_resource 'Kal/src/Kal.bundle/kal_left_arrow@2x.png'
install_resource 'Kal/src/Kal.bundle/kal_marker.png'
install_resource 'Kal/src/Kal.bundle/kal_marker@2x.png'
install_resource 'Kal/src/Kal.bundle/kal_marker_dim.png'
install_resource 'Kal/src/Kal.bundle/kal_marker_dim@2x.png'
install_resource 'Kal/src/Kal.bundle/kal_marker_selected.png'
install_resource 'Kal/src/Kal.bundle/kal_marker_selected@2x.png'
install_resource 'Kal/src/Kal.bundle/kal_marker_today.png'
install_resource 'Kal/src/Kal.bundle/kal_marker_today@2x.png'
install_resource 'Kal/src/Kal.bundle/kal_right_arrow.png'
install_resource 'Kal/src/Kal.bundle/kal_right_arrow@2x.png'
install_resource 'Kal/src/Kal.bundle/kal_tile.png'
install_resource 'Kal/src/Kal.bundle/kal_tile_dim_text_fill.png'
install_resource 'Kal/src/Kal.bundle/kal_tile_selected.png'
install_resource 'Kal/src/Kal.bundle/kal_tile_text_fill.png'
install_resource 'Kal/src/Kal.bundle/kal_tile_today.png'
install_resource 'Kal/src/Kal.bundle/kal_tile_today_selected.png'
