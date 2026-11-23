#!/bin/bash
set -euo pipefail

build=$(cd "$1" && pwd)
scripts=$(cd "$(dirname "$0")" && pwd)
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT

export TMPDIR="$scratch/temp"
export MS2K_HOME="$scratch/no-roms"
mkdir -p "$TMPDIR" "$MS2K_HOME"
cd "$scratch"

# These filenames follow the loader convention. The current shell stays alive
# while both plugin hosts run. A reaped child provides an exited PID.
sleep 0.01 &
exited=$!
wait "$exited"
for directory in MS2000R_engines MS2000R_au_engines; do
    path="$TMPDIR/$directory"
    mkdir "$path"
    touch "$path/engine_$$_1" "$path/engine_${exited}_1" "$path/engine_unrelated"
done

"$build/source/plugin/MS2000R_HostTest_artefacts/Release/MS2000R_HostTest" \
    "$build/VST3_multi/MS2000R.vst3" "$scratch/smoke.wav" 48000 512 1

ditto "$build/AU_multi/MS2000R.component" "$scratch/MS2000R.component"
clang++ -std=c++17 "$scripts/check-au-engine-retry.cpp" -o "$scratch/check-au"
"$scratch/check-au" "$scratch/MS2000R.component"

for directory in MS2000R_engines MS2000R_au_engines; do
    path="$TMPDIR/$directory"
    test -f "$path/engine_$$_1"
    test -f "$path/engine_unrelated"
    test ! -e "$path/engine_${exited}_1"
    echo "$directory: live and unrelated files preserved, exited engine removed"
done
