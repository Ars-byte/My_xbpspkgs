#!/bin/bash
# Build trinity-launcher .xbps from prebuilt tarball
set -e

VERSION="2.6.0"
PKGNAME="trinity-launcher"
WORKDIR="$(cd "$(dirname "$0")" && pwd)"
SRCDIR="/tmp/trinity-build"
DESTDIR="$WORKDIR/packages/pkg-pool/trinity-destdir"

rm -rf "$DESTDIR"
mkdir -p "$DESTDIR"

# Copy entire usr tree from the tarball
cp -a "$SRCDIR/usr" "$DESTDIR/"

# Also add a license placeholder (MIT based on repo)
mkdir -p "$DESTDIR/usr/share/licenses/$PKGNAME"

# Create wrapper symlink for trinity-launcher (the binary is /usr/bin/trinity)
# Make sure there's a trinity-launcher command that runs trinity
cat > "$DESTDIR/usr/bin/trinity-launcher" << 'SCRIPT'
#!/bin/bash
exec /usr/bin/trinity "$@"
SCRIPT
chmod 755 "$DESTDIR/usr/bin/trinity-launcher"

echo "Building trinity-launcher xbps..."
cd "$WORKDIR/packages"
xbps-create \
    -A x86_64 \
    -n "trinity-launcher-${VERSION}_1" \
    -s "Trinity Launcher - Minecraft Bedrock Launcher" \
    -S "Trinity Launcher is a Minecraft Bedrock Edition launcher for Linux built with C++ and Qt. Features a modern UI, version management, Discord integration, and multi-language support." \
    -H "https://github.com/Trinity-LA/Trinity-Launcher" \
    -l "MIT" \
    -m "Ars-Byte <ezequieldtz@tuta.io>" \
    --compression zstd \
    "$DESTDIR"

echo "trinity-launcher built OK"