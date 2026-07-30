#!/bin/bash
# Build pytter .xbps — internet speed test
set -e

VERSION="1.0.0"
PKGNAME="pytter"
WORKDIR="$(cd "$(dirname "$0")" && pwd)"
DESTDIR="$WORKDIR/packages/pkg-pool/pytter-destdir"

rm -rf "$DESTDIR"
mkdir -p "$DESTDIR/usr/bin"
mkdir -p "$DESTDIR/usr/share/$PKGNAME"
mkdir -p "$DESTDIR/usr/share/licenses/$PKGNAME"

# Copy source
cp -a /home/ars/Projects/pytter/main.py "$DESTDIR/usr/share/$PKGNAME/"
cp -a /home/ars/Projects/pytter/src "$DESTDIR/usr/share/$PKGNAME/"
cp /home/ars/Projects/pytter/LICENSE "$DESTDIR/usr/share/licenses/$PKGNAME/"

# Wrapper
cat > "$DESTDIR/usr/bin/pytter" << 'EOF'
#!/bin/bash
exec python3 /usr/share/pytter/main.py "$@"
EOF
chmod 755 "$DESTDIR/usr/bin/pytter"

echo "Building pytter xbps..."
cd "$WORKDIR/packages"
xbps-create \
    -A x86_64 \
    -n "pytter-${VERSION}_1" \
    -s "Terminal internet speed test (Python)" \
    -S "A terminal-based internet speed test with a live TUI dashboard. Measures ping and bandwidth using parallel TCP streams against globally distributed servers. No external dependencies." \
    -H "https://github.com/Ars-byte/pytter" \
    -l "MIT" \
    -m "$MAINTAINER" \
    -D "python3" \
    --compression zstd \
    "$DESTDIR"

echo "pytter built OK"