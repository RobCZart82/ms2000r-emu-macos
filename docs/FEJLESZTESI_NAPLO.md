# Fejlesztési napló

A `main` a saját macOS-változat kiadási ága. Minden új hibát, javítást és ötletet az alábbi nyilvántartásban követünk. Új tételnél rögzítsd az állapotot, a reprodukciót vagy a célt, a kapcsolódó PR-t és az ellenőrzés eredményét. A kiadási tervet a [roadmap](macos-roadmap.md) egészíti ki.

## Elkészült

| Tétel | Eredmény és ellenőrzés |
| --- | --- |
| ARM64 indítási összeomlás | Javítva. A diagnosztikai kiírás kihagyja az ARM64-en hiányzó DSP belépési pontot. A helyi ROM-os hangteszt sikeres volt. [Upstream #10](https://github.com/Tuth/ms2000r-emu/pull/10) |
| v1.0.0 telepítők | Kiadva ARM64-re és AVX2-es Intelre. VST3, AU és standalone külön választható. A hangtesztek Apple Siliconon és Rosetta alatt futottak. [Kiadás](https://github.com/RobCZart82/ms2000r-emu-macos/releases/tag/v1.0.0) |
| Kétnyelvű útmutató | Az [angol](../README.md) és [magyar](../README_HUN.md) útmutató a `main` ágon van. |
| Inkrementális AU és VST3 csomagolás | Javítva a forrásban. Újrafordításkor a csomagban is frissül a motor. ARM64-en az újracsomagolás, aláírás és ROM-os hangteszt sikeres. Tervezett kiadás: v1.0.1. [PR #2](https://github.com/RobCZart82/ms2000r-emu-macos/pull/2) |

## Nyitott hibák és ellenőrzések

| Tétel | Állapot és következő lépés |
| --- | --- |
| Párhuzamos pluginbetöltés | Reprodukálva mindkét betöltőben. Másik élő folyamat motorfájlját is törölheti. A célzott javítás és a többfolyamatos regressziós próba v1.0.1 tétel. [Upstream #17](https://github.com/Tuth/ms2000r-emu/pull/17) |
| DSP fordítói figyelmeztetés | Nyitott. A mellékelt DSP-kód negatív előjeles értékeket tol el bitenként. Javítás előtt a határértékeket és a hangkimenetet ellenőrizni kell. |
| Kis audiopuffer | Nyitott. A helyi 44,1 kHz / 128 mintás teszten előfordult időtúllépés. Megismétlendő valódi DAW-ban. |
| Telepítési és hostteszt | Nyitott. A natív Intel CI után is külön tétel a fizikai Intel Mac, az AU felismerése, a DAW-ból visszatöltött projekt és a teljes telepítési próba. |

## Ötletek

- Panelarány megtartása ablakméretezéskor. [Upstream #11](https://github.com/Tuth/ms2000r-emu/pull/11)
- Opcionális késleltetésjelentés a DAW-nak. [Upstream #12](https://github.com/Tuth/ms2000r-emu/pull/12)
- Apple Developer ID aláírás és notarizáció, amikor rendelkezésre állnak a kiadói jogosultságok.
- Nyolchangos AU és sötét panel külön későbbi kísérletként. [Források a roadmapben](macos-roadmap.md#bringing-in-upstream-and-community-changes)

## v1.0.1 javítókiadás

**Állapot:** tervezett. A fő javítás az inkrementális AU/VST3 csomagolás és a párhuzamos betöltés hibája. A [részletes hibavizsgálat és átvételi terv](V1.0.1_ELLENORZES.md) tartalmazza a reprodukciót és a kiadási ellenőrzőlistát. Új hangfunkció nem része ennek a javítókiadásnak.

1. A kiadási változtatások PR-en keresztül kerülnek a `main` ágra. A [macOS CI](../.github/workflows/macos.yml) külön ARM64 és Intel futást indít.
2. Mindkét job fordítsa le a VST3-at, az AU-t és a standalone alkalmazást. Ellenőrizze a firmware nélküli VST3-betöltést, a csomagválasztókat, az architektúrát, a célmappákat és a bundle-aláírásokat. A próbacsomagokat a futás mellékletként tárolja.
3. A két GitHub-ellenőrzés sikeres futása után legyenek kötelezőek a védett `main` ágon. A kiadás csak zöld, a kiadási commitra vonatkozó ellenőrzések után készülhet.
4. A firmware helyi marad. Kiadás előtt mindkét architektúrán rögzítsük a ROM-os hangtesztet, a tesztkörnyezetet és a telepítés eredményét.
5. Sikeres ellenőrzés után a `v1.0.1` taghez kerülhet a két telepítő, a hozzájuk tartozó forrás, a SHA-256 ellenőrzőösszegek és a kiadási megjegyzések.
