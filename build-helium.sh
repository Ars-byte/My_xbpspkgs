#!/bin/bash
# build-helium.sh — Build Helium .xbps from upstream .deb
# Run this on Void Linux to manually build the package.
set -e

PKGNAME="helium-bin"
MAINTAINER="Zeke Ezequielgk <ezequieldtz@tuta.io>"
GITHUB_REPO="imputnet/helium-linux"
WORKDIR="$(cd "$(dirname "$0")" && pwd)"
DESTDIR="$WORKDIR/pkg-destdir"

cleanup() {
    rm -rf "$WORKDIR/deb-root" "$WORKDIR/$DEB_FILE" "$DESTDIR" /tmp/helium-ctrl
}
trap cleanup EXIT

echo "===== Helium .xbps Builder ====="

# 1. Fetch latest release
echo "[1/5] Fetching latest release from $GITHUB_REPO..."
API_JSON=$(curl -s "https://api.github.com/repos/$GITHUB_REPO/releases/latest")
DOWNLOAD_URL=$(echo "$API_JSON" | jq -r '.assets[] | select(.name | endswith("_amd64.deb")) | .browser_download_url')
DEB_FILE=$(echo "$API_JSON" | jq -r '.assets[] | select(.name | endswith("_amd64.deb")) | .name')
UPSTREAM_VERSION=$(echo "$DEB_FILE" | sed 's/helium-bin_\(.*\)_amd64.deb/\1/')

if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" = "null" ]; then
    echo "ERROR: Could not find amd64 .deb in latest release."
    exit 1
fi
echo "  Version: $UPSTREAM_VERSION"

# 2. Download
echo "[2/5] Downloading $DEB_FILE..."
curl -sL -o "$WORKDIR/$DEB_FILE" "$DOWNLOAD_URL"
echo "  Downloaded: $(du -h "$WORKDIR/$DEB_FILE" | cut -f1)"

# 3. Extract
echo "[3/5] Extracting..."
rm -rf "$WORKDIR/deb-root"
mkdir -p "$WORKDIR/deb-root"
cd "$WORKDIR/deb-root"
ar x "$WORKDIR/$DEB_FILE"
tar xf data.tar.xz -C .
mkdir -p /tmp/helium-ctrl
tar xf control.tar.xz -C /tmp/helium-ctrl 2>/dev/null || true
cd "$WORKDIR"

# 4. Optimize + Package
echo "[4/5] Optimizing and packaging..."

# Size optimizations
rm -f deb-root/opt/helium/chromedriver
find deb-root/opt/helium -name "*.info" -type f -delete 2>/dev/null || true
find deb-root/opt/helium/locales -type f ! -name "en-US.pak" -delete 2>/dev/null || true
rm -f deb-root/opt/helium/libvk_swiftshader.so
rm -f deb-root/opt/helium/vk_swiftshader_icd.json
rm -f deb-root/opt/helium/chrome_200_percent.pak

# Build destdir
rm -rf "$DESTDIR"
mkdir -p "$DESTDIR"
cp -a deb-root/opt "$DESTDIR/"
cp -a deb-root/usr "$DESTDIR/"

# Wrapper
mkdir -p "$DESTDIR/usr/bin"
rm -f "$DESTDIR/usr/bin/helium"
cat > "$DESTDIR/usr/bin/helium" << 'EOF'
#!/bin/sh
export CHROME_VERSION_EXTRA="void-xbps"
CHROME_WRAPPER="$(readlink -f "$0")"
export CHROME_WRAPPER
export LD_LIBRARY_PATH="/opt/helium:${LD_LIBRARY_PATH}"
exec /opt/helium/helium "$@"
EOF
chmod 755 "$DESTDIR/usr/bin/helium"

# Build
XBPS_VERSION=$(echo "${UPSTREAM_VERSION}" | sed 's/-/_/')
xbps-create \
    -A x86_64 \
    -n "${PKGNAME}-${XBPS_VERSION}" \
    -s "Helium - privacy-first Chromium-based web browser" \
    -S "Helium is a privacy-first web browser based on Chromium with unbiased ad-blocking, no bloat, and no noise." \
    -m "$MAINTAINER" \
    -H "https://helium.computer" \
    -l "GPL-3.0-only" \
    --compression zstd \
    "$DESTDIR"

XBPS_FILE="${PKGNAME}-${XBPS_VERSION}.x86_64.xbps"

echo "[5/5] Done!"
echo "  Package: $WORKDIR/$XBPS_FILE"
echo "  Size:    $(du -h "$WORKDIR/$XBPS_FILE" | cut -f1)"
echo ""
echo "  Install: sudo xbps-install -R . $PKGNAME"