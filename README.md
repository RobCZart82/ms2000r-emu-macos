# MS2000R for macOS

[Magyar útmutató](README_HUN.md) · [Download installers](https://github.com/RobCZart82/ms2000r-emu-macos/releases/latest)

Play the Korg MS2000R rack synthesizer on your Mac. Use it as a VST3 or Audio Unit instrument in a DAW, or open the standalone app. This unofficial macOS fork runs the original MS2000R firmware in the emulator.

## Install

1. Download the `.pkg` for your Mac from [Releases](https://github.com/RobCZart82/ms2000r-emu-macos/releases/latest). Choose **arm64** for Apple Silicon or **x86_64** for an Intel Mac with AVX2.
2. Open the installer and choose **Customize** to select the components you want.

| Component | Where to find it |
| --- | --- |
| **VST3** | Your DAW’s VST3 instrument list |
| **Audio Unit (AU)** | Your DAW’s Audio Unit instrument list, including Logic Pro and GarageBand |
| **Standalone** | `MS2000R.app` in Applications |

The v1.0.0 installers are unsigned and not notarized. macOS may block them. The build targets macOS 11 or later. The Intel version was tested under Rosetta.

## Add your ROM files

The installer does not include firmware. Put these files from your own hardware together in one folder, for example `Documents/MS2000R`:

- `flash.bin` — main firmware flash, 1 MiB.
- `boot-362.bin` or `boot-362.ms2000.bin` — DSP boot ROM, 768 bytes. It can also go in the `full FW` subfolder.
- `hd44780_a00.bin` — optional LCD character ROM.

Open the app or load **MS2000R** on an instrument track. In the plugin, choose **Settings → Choose the MS2000 folder…**. The standalone app asks for the folder on first launch if it cannot find the ROMs. Give the firmware a few seconds to start before playing. If the plugin is missing from your DAW, restart it or rescan its plugins.

## Project links

[Original project](https://github.com/Tuth/ms2000r-emu) · [Upstream documentation](docs/UPSTREAM.md) · [Build and packaging](packaging/README-macos.md) · [Roadmap](docs/macos-roadmap.md) · [GPL-3.0 license](LICENSE.md)
