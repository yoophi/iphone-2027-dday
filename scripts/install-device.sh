#!/bin/zsh
set -euo pipefail
cd "${0:A:h}/.."
if (( $# != 1 )); then
    print -u2 'Usage: ./scripts/install-device.sh <iPhone UDID>'
    print -u2 'Find the UDID with: xcrun devicectl list devices'
    exit 2
fi
device_udid=$1
xcodebuild -project NewYear2027.xcodeproj -scheme NewYear2027 \
    -configuration Debug -destination "id=$device_udid" \
    -derivedDataPath build/install \
    -allowProvisioningUpdates -allowProvisioningDeviceRegistration build
xcrun devicectl device install app --device "$device_udid" \
    build/install/Build/Products/Debug-iphoneos/NewYear2027.app
xcrun devicectl device process launch --device "$device_udid" com.yoophi.newyear2027
