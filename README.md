# My_xbpspkgs

My xbps packages for **Void Linux** :) — una colección de paquetes `.xbps` construidos por [Ars-Byte](https://github.com/Ars-byte).

## Paquetes disponibles

| Paquete | Versión | Descripción | Tipo | Origen |
|---|---|---|---|---|
| `genovalauncher` | 1.3.1 | Launcher de Minecraft Bedrock (PySide6/Qt6) | Grande | [Ars-byte/GenovaLauncher](https://github.com/Ars-byte/GenovaLauncher) |
| `helium-bin` | 0.14.9.1 | Navegador web Chromium enfocado en privacidad | Grande | [imputnet/helium-linux](https://github.com/imputnet/helium-linux) |
| `pcsx2` | 2.6.3 | Emulador de PlayStation 2 (con plugins Qt incluidos) | Grande | [pcsx2.net](https://pcsx2.net/) |
| `imgview` | 1.0.0 | Visor de imágenes en terminal (C++) | Pequeño | [Ars-byte/Imgview](https://github.com/Ars-byte/Imgview) |
| `pytrix` | 1.0.0 | Matrix digital rain en terminal (Python) | Pequeño | [Ars-byte/Pytrix](https://github.com/Ars-byte/Pytrix) |
| `pytter` | 1.0.0 | Test de velocidad de internet con TUI (Python) | Pequeño | [Ars-byte/pytter](https://github.com/Ars-byte/pytter) |

> **Paquetes pequeños** (`< 50 MB`): viven directamente en este repo, en `packages/`.
> **Paquetes grandes** (`>= 50 MB`): se descargan desde el [release v1.0.0](https://github.com/Ars-byte/My_xbpspkgs/releases/tag/v1.0.0).
>
> **Nota**: `pcsx2` incluye los plugins Qt de plataforma (wayland, xcb) en el wrapper, por lo que funciona sin el error `qt.qpa.plugin: Could not find the Qt platform plugin`.
>
> **Nota**: `trinity-launcher` fue eliminado del repositorio. Si lo tenías instalado, desinstálalo con `doas xbps-remove trinity-launcher`.

---

## Instalación

### Opción A — Descargar y instalar paquetes individuales

Esta es la forma más directa: descargas el `.xbps` que quieres y lo instalas con `xbps-rindex` + `xbps-install`.

#### 1. Paquetes pequeños (directo del repo)

```bash
# imgview
doas xbps-rindex -a /home/ars/Downloads/imgview-1.0.0_1.x86_64.xbps
doas xbps-install --repository=/home/ars/Downloads imgview

# pytrix
doas xbps-rindex -a /home/ars/Downloads/pytrix-1.0.0_1.x86_64.xbps
doas xbps-install --repository=/home/ars/Downloads pytrix

# pytter
doas xbps-rindex -a /home/ars/Downloads/pytter-1.0.0_1.x86_64.xbps
doas xbps-install --repository=/home/ars/Downloads pytter
```

#### 2. Paquetes grandes (desde el release)

Descarga el `.xbps` desde [Releases v1.0.0](https://github.com/Ars-byte/My_xbpspkgs/releases/tag/v1.0.0) a tu carpeta de Downloads, y luego:

```bash
# genovalauncher
doas xbps-rindex -a /home/ars/Downloads/genovalauncher-1.3.1_1.x86_64.xbps
doas xbps-install --repository=/home/ars/Downloads genovalauncher

# helium-bin
doas xbps-rindex -a /home/ars/Downloads/helium-bin-0.14.9.1_1.x86_64.xbps
doas xbps-install --repository=/home/ars/Downloads helium-bin

# pcsx2
doas xbps-rindex -a /home/ars/Downloads/pcsx2-2.6.3_1.x86_64.xbps
doas xbps-install --repository=/home/ars/Downloads pcsx2

```

### Opción B — Instalar todo de una

Descarga todos los `.xbps` (los 3 pequeños del repo + los 3 grandes del release) a la misma carpeta, por ejemplo `~/Downloads`, y entonces:

```bash
# Indexar todos los paquetes de la carpeta
doas xbps-rindex -a ~/Downloads/*.xbps

# Instalar todos
doas xbps-install --repository=/home/ars/Downloads \
    imgview pytrix pytter \
    genovalauncher helium-bin pcsx2
```

### Opción C — Agregar el repositorio permanentemente

Si quieres que los paquetes pequeños (los que están en `packages/` del repo) estén siempre disponibles sin descargar nada manualmente:

```bash
# Apuntar xbps al pool de paquetes hosteado en GitHub
echo "repository=https://raw.githubusercontent.com/Ars-byte/My_xbpspkgs/main/packages" | \
    doas tee /etc/xbps.d/20-my-xbpspkgs.conf

# Sincronizar e instalar
doas xbps-install -S
doas xbps-install imgview pytrix pytter
```

> Nota: solo los paquetes pequeños están en el pool de GitHub. Los grandes siguen necesitando descarga manual desde el release.

---

## Uso

```bash
# Visor de imágenes en terminal
imgview foto.jpg
imgview -w 80 -h 40 foto.png      # tamaño forzado
imgview -g -d foto.jpg            # grises + dithering
imgview -s 3 img1.png img2.jpg    # slideshow cada 3s

# Matrix digital rain
pytrix
pytrix -c cyan -s 8               # cian, rápido
pytrix -a -l 50 --density 0.5     # ASCII, trails largos, disperso

# Test de velocidad de internet
pytter
pytter -hideip                    # oculta tu IP

# Launcher de Minecraft Bedrock
genovalauncher

# Navegador web
helium

# Emulador PS2
pcsx2
```

---

## Compilar los paquetes localmente

Cada paquete tiene su propio `build-*.sh`. Necesitas Void Linux con `xbps-create` y `xbps-rindex` instalados.

```bash
git clone https://github.com/Ars-byte/My_xbpspkgs.git
cd My_xbpspkgs

# Compilar todos los paquetes pequeños
bash build-imgview.sh    # requiere: g++, (stb_image bundles)
bash build-pytrix.sh     # requiere: python3
bash build-pytter.sh     # requiere: python3

# Paquetes grandes (descargan/buildan de upstream)
bash build-helium.sh         # requiere: curl, jq, binutils, ar
bash build-pcsx2.sh          # requiere: el AppImage de PCSX2 en Downloads
bash build-genovalauncher.sh # requiere: el dist de GenovaLauncher ya construido
```

Los `.xbps` resultantes caen en `packages/`.

---

## Licencias

| Paquete | Licencia |
|---|---|
| imgview | MIT |
| pytrix | MIT |
| pytter | MIT |
| genovalauncher | GPL-3.0 |
| helium-bin | GPL-3.0 |
| pcsx2 | GPL-3.0 |

---

## Autor

**Ars-Byte** — [GitHub](https://github.com/Ars-byte) :)
