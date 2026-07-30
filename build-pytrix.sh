#!/bin/bash
# Build pytrix .xbps — Matrix rain (Python)
set -e

VERSION="1.0.0"
PKGNAME="pytrix"
WORKDIR="$(cd "$(dirname "$0")" && pwd)"
DESTDIR="$WORKDIR/packages/pkg-pool/pytrix-destdir"

rm -rf "$DESTDIR"
mkdir -p "$DESTDIR/usr/bin"
mkdir -p "$DESTDIR/usr/share/licenses/$PKGNAME"

# Install script
cp /home/ars/Projects/Pytrix/pytrix.py "$DESTDIR/usr/share/licenses/$PKGNAME"/
cp /home/ars/Projects/Pytrix/README.md "$DESTDIR/usr/share/licenses/$PKGNAME/"

# Wrapper
cat > "$DESTDIR/usr/bin/pytrix" << 'EOF'
#!/bin/bash
exec python3 /usr/share/licenses/pytrix/pytrix.py "$@"
EOF
chmod 755 "$DESTDIR/usr/bin/pytrix"

echo "Building pytrix xbps..."
cd "$WORKDIR/packages"
xbps-create \
    -A x86_64 \
    -n "pytrix-${VERSION}_1" \
    -s "Matrix digital rain in your terminal (Python)" \
    -S "Matrix digital rain effect written in Python using curses. Supports multiple colors, speed control, ASCII/katakana charsets, and customizable density." \
    -H "https://github.com/Ars-byte/Pytrix" \
    -l "MIT" \
    -m "Ars-Byte <ezequieldtz@tuta.io>" \
    -D "python3" \
    --compression zstd \
    "$DESTDIR"

echo "pytrix built OK"