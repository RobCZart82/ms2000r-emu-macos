# macOS fork roadmap

The fork’s `main` branch is the macOS development and release branch. Fork releases use independent version numbers starting at `v1.0.0`. Release notes record the upstream version and commit, imported changes, and validation results.

## First release

- [x] Preserve the tested Apple Silicon VST3 startup fix on the fork's main branch.
- [ ] Build AU and VST3 for arm64 and x86_64. The current Intel target requires AVX2.
- [ ] Fix incremental packaging so rebuilt engines are included in the VST3 and AU bundles.
- [ ] Validate AU with auval and check ROM-backed MIDI audio, project recall, and multiple instances. Record whether x86_64 testing ran on Intel hardware or through Rosetta.
- [ ] Publish separate arm64 and x86_64 PKG installers with selectable AU and VST3 components. Include corresponding buildable source and license notices. Users supply their ROMs separately. Record the signing and notarization status.

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
