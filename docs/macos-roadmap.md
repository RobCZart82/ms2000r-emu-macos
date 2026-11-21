# macOS fork roadmap

The fork’s `main` branch is the macOS development and release branch. Fork releases use independent version numbers starting at `v1.0.0`. Release notes record the upstream version and commit, imported changes, and validation results.

## Release status

- **Published in [v1.0.0](https://github.com/RobCZart82/ms2000r-emu-macos/releases/tag/v1.0.0)**: Apple Silicon startup fix and separate arm64 and x86_64 installers with VST3, AU and standalone options. The release includes source archives. Intel requires AVX2.
- **Validated for v1.0.0**: ROM-backed audio in all three formats on Apple Silicon and under Rosetta for x86_64. See the release notes for the test methods and signing status.
- **Next**: physical Intel hardware, AU discovery and validation with `auval`, DAW sessions, and installer end-to-end testing.

## Bringing in upstream and community changes

Review releases and commits on upstream main, open pull requests, and relevant community fork branches when preparing a release. Integrate upstream main into the fork’s main via a pull request, and bring selected community fixes into separate commits with links to their source and credit to their authors. Check license compatibility and review the actual source diff. When upstream incorporates a local fix, reconcile both versions. Build and test the combined source before tagging a release.

Candidates for separate review and testing:

- [PR #17](https://github.com/Tuth/ms2000r-emu/pull/17): isolate the temporary engine cleanup fix and verify simultaneous plugin scans and instances.
- [PR #11](https://github.com/Tuth/ms2000r-emu/pull/11): preserve the panel's aspect ratio when resizing.
- [PR #12](https://github.com/Tuth/ms2000r-emu/pull/12): evaluate optional latency reporting in a DAW.
- [PR #20](https://github.com/Tuth/ms2000r-emu/pull/20): evaluate individual macOS and DSP portability changes with ROM-backed regression tests.
- [8-voice fork](https://github.com/simon-mcevoy/ms2000r-emu-8voice/tree/macos-8-voice): evaluate as an optional AU variant separately from the hardware-faithful release.
- [Sergio Frias fork](https://github.com/sergiofrias/ms2000r-emu): consider the charcoal panel as an optional theme.

[PR #10](https://github.com/Tuth/ms2000r-emu/pull/10) overlaps the existing local Apple Silicon fix. Reconcile the patches if upstream merges it.
