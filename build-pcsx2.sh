#!/bin/bash
# Build pcsx2 .xbps from AppImage
set -e

VERSION="2.6.3"
PKGNAME="pcsx2"
WORKDIR="$(cd "$(dirname "$0")" && pwd)"
DESTDIR="$WORKDIR/packages/pkg-pool/pcsx2-destdir"
APPDIR="/tmp/pcsx2-build/squashfs-root"

rm -rf "$DESTDIR"
mkdir -p "$DESTDIR/usr/bin"
mkdir -p "$DESTDIR/usr/lib/pcsx2"
mkdir -p "$DESTDIR/usr/share/applications"
mkdir -p "$DESTDIR/usr/share/icons/hicolor/256x256/apps"
mkdir -p "$DESTDIR/usr/share/pixmaps"

# Copy binary
cp "$APPDIR/usr/bin/pcsx2-qt" "$DESTDIR/usr/lib/pcsx2/pcsx2-qt"
chmod 755 "$DESTDIR/usr/lib/pcsx2/pcsx2-qt"

# Copy bundled libs
cp -a "$APPDIR/usr/lib/"* "$DESTDIR/usr/lib/pcsx2/" 2>/dev/null || true

# Copy resources
cp -a "$APPDIR/usr/bin/resources" "$DESTDIR/usr/lib/pcsx2/" 2>/dev/null || true
cp -a "$APPDIR/usr/bin/translations" "$DESTDIR/usr/lib/pcsx2/" 2>/dev/null || true

# Desktop file
cp "$APPDIR/net.pcsx2.PCSX2.desktop" "$DESTDIR/usr/share/applications/pcsx2.desktop" 2>/dev/null || true

# Icon
if [ -f "$APPDIR/PCSX2.png" ]; then
    cp "$APPDIR/PCSX2.png" "$DESTDIR/usr/share/icons/hicolor/256x256/apps/pcsx2.png"
    cp "$APPDIR/PCSX2.png" "$DESTDIR/usr/share/pixmaps/pcsx2.png"
fi

# Wrapper script
cat > "$DESTDIR/usr/bin/pcsx2" << 'EOF'
#!/bin/bash
export LD_LIBRARY_PATH="/usr/lib/pcsx2:${LD_LIBRARY_PATH}"
exec /usr/lib/pcsx2/pcsx2-qt "$@"
EOF
chmod 755 "$DESTDIR/usr/bin/pcsx2"

# Deps
DEPS="gtk+3 libX11 libXext libXi libXrandr libXrender libXfixes libXcursor libglvnd libdrm libxkbcommon zlib bzip2 freetype fontconfig libpng pulseaudio alsa-lib dbus-glib SDL2 eudev-libgudev libavcodec libavformat libavutil libswresample libswscale"

echo "Building pcsx2 xbps..."
cd "$WORKDIR/packages"
xbps-create \
    -A x86_64 \
    -n "pcsx2-${VERSION}_1" \
    -s "PCSX2 - PlayStation 2 Emulator" \
    -S "PCSX2 is a free and open-source PlayStation 2 (PS2) emulator. Its purpose is to emulate the PS2's hardware, using a combination of MIPS CPU Interpreters, Recompilers and a Virtual Machine which manages hardware states and PS2 system memory." \
    -H "https://pcsx2.net/" \
    -l "GPL-3.0-only" \
    -m "Ars-Byte <ezequieldtz@tuta.io>" \
    --compression zstd \
    "$DESTDIR"

echo "pcsx2 built: $(ls "$WORKDIR/packages/pool"/pcsx2-*.xbps 2>/dev/null)"