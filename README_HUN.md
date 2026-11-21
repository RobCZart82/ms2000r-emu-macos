# MS2000R macOS-re

[English guide](README.md) · [Telepítők letöltése](https://github.com/RobCZart82/ms2000r-emu-macos/releases/latest)

A Korg MS2000R rack szintetizátor emulátora Macre. A hangszert használhatod VST3 vagy Audio Unit pluginként a DAW-ban, illetve önálló alkalmazásként. Ez a nem hivatalos macOS-fork az eredeti MS2000R firmware-t futtatja az emulátorban.

## Telepítés

1. A [Kiadások](https://github.com/RobCZart82/ms2000r-emu-macos/releases/latest) oldalról töltsd le a Mac típusához illő `.pkg` fájlt. Apple Siliconhoz az **arm64**, AVX2-t támogató Intel Machez az **x86_64** változatot válaszd.
2. Nyisd meg a telepítőt, majd a **Testreszabás** képernyőn jelöld be a kívánt összetevőket.

| Összetevő | Hol találod? |
| --- | --- |
| **VST3** | A DAW VST3 hangszerei között |
| **Audio Unit (AU)** | Az AU hangszerek között, például a Logic Próban vagy a GarageBandben |
| **Önálló alkalmazás** | Az Alkalmazások mappában, `MS2000R.app` néven |

A v1.0.0 telepítői Apple-aláírás és notarizáció nélküliek, ezért a macOS blokkolhatja őket. A build célverziója macOS 11 vagy újabb. Az Intel-változatot Rosetta alatt teszteltük.

## ROM-fájlok megadása

A firmware nincs a telepítőben. A saját hangszeredből származó fájlokat tedd egy mappába, például a `Dokumentumok/MS2000R` mappába:

- `flash.bin` — a fő firmware, 1 MiB.
- `boot-362.bin` vagy `boot-362.ms2000.bin` — a DSP indító ROM-ja, 768 bájt. A `full FW` almappába is kerülhet.
- `hd44780_a00.bin` — opcionális LCD-karakterkészlet.

Indítsd el az alkalmazást, vagy töltsd be az **MS2000R**-t egy hangszersávra. A pluginban a **Settings → Choose the MS2000 folder…** menüponttal válaszd ki a ROM-mappát. Az önálló alkalmazás első indításkor rákérdez a mappára, ha nem találja a fájlokat. Játék előtt várj néhány másodpercet, amíg a firmware elindul. Ha a DAW nem listázza a plugint, indítsd újra vagy indíts plugin-újrakeresést.

## A projektről

[Eredeti projekt](https://github.com/Tuth/ms2000r-emu) · [Eredeti dokumentáció](docs/UPSTREAM.md) · [Fordítás és csomagolás](packaging/README-macos.md) · [Fejlesztési terv](docs/macos-roadmap.md) · [GPL-3.0 licenc](LICENSE.md)
