# macOS installers

Each macOS release provides two installers, one for Apple Silicon (arm64) and one for Intel (x86_64 with AVX2). In Installer's Customize screen, select the formats you want:

| Component | Installed at |
| --- | --- |
| VST3 instrument | `/Library/Audio/Plug-Ins/VST3/MS2000R.vst3` |
| Audio Unit instrument | `/Library/Audio/Plug-Ins/Components/MS2000R.component` |
| Standalone application | `/Applications/MS2000R.app` |

Provide your own ROMs as described in the upstream README. Select the ROM folder in Settings in the plugin or when prompted by the app. The package does not contain firmware.

## Build and package

From the source tree on macOS with Xcode Command Line Tools, Git, Python 3 and CMake installed:

```sh
for arch in arm64 x86_64; do
    build="build-$arch.nosync"
    cmake -S . -B "$build" -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_OSX_ARCHITECTURES="$arch" -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 \
        -DMS2K_BUILD_VST3=ON -DMS2K_MAC_GUI=ON
    cmake --build "$build" --target MS2000R_Shim MS2000R_AUShim MS2000R_app --clean-first --parallel
    ./packaging/macos-pkg.sh "$build" "$arch" 1.0.0 ./packages
done
```

Use fresh build trees or clean builds. The upstream shim packaging step can otherwise leave old engine files in the final bundles. The packaging script checks architectures and ad-hoc signatures. Developer ID signing and notarization require Apple credentials and are separate from this build.
