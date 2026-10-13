#!/bin/sh
# Extract official OldUnreal game media into the chosen destination.
set -eu
ISO=${1:?ISO}; DEST=${2:?destination}; WORK=${3:?work directory}
[ -f "$ISO" ] || exit 2
mkdir -p "$DEST" "$WORK"
: > "$DEST/.nomedia"
echo "STEP 1 Extraction des donnees"
7z x -y -bso0 -bsp0 -o"$WORK" "$ISO" "HELP/*"
if [ -d "$WORK/HELP" ]; then mkdir -p "$DEST/Help"; cp -rf "$WORK/HELP/." "$DEST/Help/"; fi
7z x -y -bso0 -bsp0 -o"$WORK" "$ISO" "MANUALS/*"
if [ -d "$WORK/MANUALS" ]; then mkdir -p "$DEST/Manuals"; cp -rf "$WORK/MANUALS/." "$DEST/Manuals/"; fi
7z x -y -bso0 -bsp0 -o"$WORK" "$ISO" "MAPS/*"
if [ -d "$WORK/MAPS" ]; then mkdir -p "$DEST/Maps"; cp -rf "$WORK/MAPS/." "$DEST/Maps/"; fi
7z x -y -bso0 -bsp0 -o"$WORK" "$ISO" "MUSIC/*"
if [ -d "$WORK/MUSIC" ]; then mkdir -p "$DEST/Music"; cp -rf "$WORK/MUSIC/." "$DEST/Music/"; fi
7z x -y -bso0 -bsp0 -o"$WORK" "$ISO" "SOUNDS/*"
if [ -d "$WORK/SOUNDS" ]; then mkdir -p "$DEST/Sounds"; cp -rf "$WORK/SOUNDS/." "$DEST/Sounds/"; fi
7z x -y -bso0 -bsp0 -o"$WORK" "$ISO" "SYSTEM/*"
if [ -d "$WORK/SYSTEM" ]; then mkdir -p "$DEST/System"; cp -rf "$WORK/SYSTEM/." "$DEST/System/"; fi
7z x -y -bso0 -bsp0 -o"$WORK" "$ISO" "TEXTURES/*"
if [ -d "$WORK/TEXTURES" ]; then mkdir -p "$DEST/Textures"; cp -rf "$WORK/TEXTURES/." "$DEST/Textures/"; fi
rm -f "$DEST/System/"*.exe "$DEST/System/"*.dll "$DEST/System/"*.bat
sync
echo "STEP 4 Termine"
