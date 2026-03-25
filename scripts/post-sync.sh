#!/bin/bash
set -e

MANIFEST="android/app/src/main/AndroidManifest.xml"

# Add permissions before </manifest>

PERMS='    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />'
sed -i "/<\/manifest>/i $PERMS" "$MANIFEST"


# Set screen orientation
sed -i 's/android:screenOrientation="[^"]*"/android:screenOrientation="landscape"/' "$MANIFEST"
# If no orientation attr exists, add it to main activity
if ! grep -q "screenOrientation" "$MANIFEST"; then
  sed -i 's/<activity/<activity android:screenOrientation="landscape"/' "$MANIFEST"
fi


# Set fullscreen theme
if ! grep -q "Theme.NoTitleBar.Fullscreen" "$MANIFEST"; then
  sed -i 's/<activity/<activity android:theme="@android:style/Theme.NoTitleBar.Fullscreen"/' "$MANIFEST"
fi



# Copy icon resources
for SIZE_DIR in mipmap-mdpi mipmap-hdpi mipmap-xhdpi mipmap-xxhdpi mipmap-xxxhdpi; do
  TARGET="android/app/src/main/res/$SIZE_DIR"
  mkdir -p "$TARGET"
  cp "resources/android/icon/$SIZE_DIR/ic_launcher.png" "$TARGET/ic_launcher.png"
  cp "resources/android/icon/$SIZE_DIR/ic_launcher_round.png" "$TARGET/ic_launcher_round.png"
  cp "resources/android/icon/$SIZE_DIR/ic_launcher_foreground.png" "$TARGET/ic_launcher_foreground.png"
done


echo "Post-sync complete"
