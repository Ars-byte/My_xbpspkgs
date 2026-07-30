#!/bin/bash
# Build imgview .xbps — terminal image viewer (C++)
set -e

VERSION="1.0.0"
PKGNAME="imgview"
WORKDIR="$(cd "$(dirname "$0")" && pwd)"
DESTDIR="$WORKDIR/packages/pkg-pool/imgview-destdir"

rm -rf "$DESTDIR"
mkdir -p "$DESTDIR/usr/bin"
mkdir -p "$DESTDIR/usr/share/licenses/imgview"

# Copy binary (already compiled)
cp "$WORKDIR/bin/imgview" "$DESTDIR/usr/bin/imgview"
chmod 755 "$DESTDIR/usr/bin/imgview"

# License
cp /home/ars/Projects/Imgview/LICENSE "$DESTDIR/usr/share/licenses/imgview/LICENSE"

echo "Building imgview xbps..."
cd "$WORKDIR/packages"
xbps-create \
    -A x86_64 \
    -n "imgview-${VERSION}_1" \
    -s "Terminal image viewer with truecolor support" \
    -S "A lightweight terminal image viewer written in C++ that renders images directly in your terminal using Unicode half-block characters and 24-bit ANSI true color. Supports JPEG, PNG, BMP, GIF, TGA, PNM, HDR, and PIC formats." \
    -H "https://github.com/Ars-byte/Imgview" \
    -l "MIT" \
    -m "Ars-Byte <ezequieldtz@tuta.io>" \
    --compression zstd \
    "$DESTDIR"

echo "imgview built OK"