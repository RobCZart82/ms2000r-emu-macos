#!/bin/bash
set -euo pipefail
if [[ $# != 4 || ! "$2" =~ ^(arm64|x86_64)$ || ! "$3" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Usage: $0 BUILD_DIR arm64|x86_64 VERSION OUTPUT_DIR" >&2
    exit 2
fi
build=$(cd "$1" && pwd)
arch=$2
version=$3
mkdir -p "$4"
output=$(cd "$4" && pwd)
temp=$(mktemp -d)
trap 'rm -rf "$temp"' EXIT
prefix=io.github.robczart82.ms2000r-emu-macos
for kind in vst3 au standalone; do
    case "$kind" in
        vst3) bundle="$build/VST3_multi/MS2000R.vst3"; dest="/Library/Audio/Plug-Ins/VST3"; exe=MS2000R ;;
        au) bundle="$build/AU_multi/MS2000R.component"; dest="/Library/Audio/Plug-Ins/Components"; exe=MS2000R ;;
        standalone) bundle="$build/MS2000R.app"; dest="/Applications"; exe=ms2000_emulator ;;
    esac
    [[ "$(lipo -archs "$bundle/Contents/MacOS/$exe")" == "$arch" ]]
    if [[ "$kind" != standalone ]]; then
        [[ "$(lipo -archs "$bundle/Contents/Resources/MS2000R_engine")" == "$arch" ]]
    fi
    codesign --verify --deep --strict "$bundle"
    mkdir "$temp/$kind"
    ditto "$bundle" "$temp/$kind/${bundle##*/}"
    pkgbuild --analyze --root "$temp/$kind" "$temp/$kind.plist"
    python3 - "$temp/$kind.plist" <<'PYTHON'
import plistlib
import sys

path = sys.argv[1]
with open(path, "rb") as stream:
    bundles = plistlib.load(stream)
for bundle in bundles:
    bundle["BundleIsRelocatable"] = False
with open(path, "wb") as stream:
    plistlib.dump(bundles, stream)
PYTHON
    pkgbuild --root "$temp/$kind" --component-plist "$temp/$kind.plist" \
        --install-location "$dest" --identifier "$prefix.$kind" \
        --version "$version" "$temp/$kind.pkg"
done

cat > "$temp/Distribution.xml" <<XML
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="2">
  <title>MS2000R for macOS $version ($arch)</title>
  <options customize="always" require-scripts="false" hostArchitectures="$arch"/>
  <domains enable_anywhere="false" enable_currentUserHome="false" enable_localSystem="true"/>
  <allowed-os-versions><os-version min="11.0"/></allowed-os-versions>
  <choices-outline>
    <line choice="vst3"/>
    <line choice="au"/>
    <line choice="standalone"/>
  </choices-outline>
  <choice id="vst3" title="VST3 instrument" description="Installs MS2000R.vst3 in /Library/Audio/Plug-Ins/VST3.">
    <pkg-ref id="$prefix.vst3"/>
  </choice>
  <choice id="au" title="Audio Unit instrument" description="Installs MS2000R.component in /Library/Audio/Plug-Ins/Components.">
    <pkg-ref id="$prefix.au"/>
  </choice>
  <choice id="standalone" title="Standalone application" description="Installs MS2000R.app in /Applications.">
    <pkg-ref id="$prefix.standalone"/>
  </choice>
  <pkg-ref id="$prefix.vst3" version="$version">vst3.pkg</pkg-ref>
  <pkg-ref id="$prefix.au" version="$version">au.pkg</pkg-ref>
  <pkg-ref id="$prefix.standalone" version="$version">standalone.pkg</pkg-ref>
</installer-gui-script>
XML
productbuild --distribution "$temp/Distribution.xml" --package-path "$temp" \
    "$output/MS2000R-macOS-v$version-$arch.pkg"
