#!/bin/bash
# Build genovalauncher .xbps from existing dist/GenovaLauncherMCPE
set -e

VERSION="1.3.1"
PKGNAME="genovalauncher"
WORKDIR="$(cd "$(dirname "$0")" && pwd)"
DIST="/home/ars/Projects/GenovaLauncher/dist/GenovaLauncherMCPE"
SRCDIR="/home/ars/Projects/GenovaLauncher"
DESTDIR="$WORKDIR/packages/pkg-pool/genova-destdir"

rm -rf "$DESTDIR"
mkdir -p "$DESTDIR/usr/bin"
mkdir -p "$DESTDIR/usr/share/genovalauncher"
mkdir -p "$DESTDIR/usr/share/applications"
mkdir -p "$DESTDIR/usr/share/icons/hicolor/256x256/apps"
mkdir -p "$DESTDIR/usr/share/licenses/$PKGNAME"

# Wrapper
cat > "$DESTDIR/usr/bin/genovalauncher" << 'SCRIPT'
#!/bin/bash
exec /usr/share/genovalauncher/GenovaLauncherMCPE "$@"
SCRIPT
chmod 755 "$DESTDIR/usr/bin/genovalauncher"

# Main app files
cp -a "$DIST"/* "$DESTDIR/usr/share/genovalauncher/"

# Desktop
cat > "$DESTDIR/usr/share/applications/genovalauncher.desktop" << 'EOF'
[Desktop Entry]
Name=GenovaLauncher
Comment=Minecraft Bedrock Launcher for Linux
Exec=genovalauncher
Icon=genovalauncher
Terminal=false
Type=Application
Categories=Game;
EOF

# Icon
cp "$SRCDIR/icon.png" "$DESTDIR/usr/share/icons/hicolor/256x256/apps/genovauncher.png"

# License
cp "$SRCDIR/LICENSE" "$DESTDIR/usr/share/licenses/$PKGNAME/LICENSE"

echo "Building genovalauncher xbps..."
cd "$WORKDIR/packages"
xbps-create \
    -A "x86_64" \
    -n "genovalauncher-${VERSION}_1" \
    -s "Minecraft Bedrock Launcher for Linux" \
    -S "GenovaLauncher is an unofficial launcher for Minecraft Bedrock Edition on Linux, powered by the mcpelauncher project. Features version management, resource packs, mods, 7 themes, and 8 languages." \
    -H "https://github.com/Ars-byte/GenovaLauncher" \
    -l "GPL-3.0-only" \
    -m "Ars-Byte <ezequieldtz@tuta.io>" \
    --compression zstd \
    "$DESTDIR"

echo "genovalauncher built OK"