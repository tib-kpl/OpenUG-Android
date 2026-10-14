# UnrealGold-Android

**Unofficial** Android launcher for **Unreal Gold** on ARM64 Android handhelds and
phones, running the native Linux ARM64 engine of the community
[OldUnreal 227 patch](https://github.com/OldUnreal/Unreal-testing). Android 8.0 or newer is required.

> [!IMPORTANT]
> This launcher contains **no game files and no game engine**. On first launch it downloads
> the OldUnreal patch from its official GitHub releases. For the game data, you can point
> it to an existing PC installation or download the game through the launcher, using the
> same media sources as [OldUnreal's official installers](https://github.com/OldUnreal/FullGameInstallers).
> Game and patch licenses apply separately from this launcher.

## Features

- **Download the game** to the folder of your choice (internal storage or SD card), or
  **use an existing installation**. The location is remembered; interrupted downloads resume
  and the installation media is checked against its expected SHA-256.
- Native ARM64 engine (OldUnreal 227) in a small embedded Linux environment: no CPU emulation.
- GPU rendering on compatible Adreno (Snapdragon) devices through Mesa Turnip + Zink,
  with software fallback. Choose 540p, 720p or 1080p in the screen's aspect ratio.
- Built-in, USB and Bluetooth controllers, physical keyboard and touch navigation.
- Separate **Return to game** and **Restart game** actions in the launcher.
- Optional engine FPS counter in the upper-right corner, beside the settings gear.
- Persistent saves and user configuration across launches and signed app updates.
- Audio through Android's selected output, with pause and silence when the app is in the
  background or the screen is locked.
- Translator, objectives/hints, inventory activation and weapon cycling on the gamepad.

Tested on the **AYN Odin 2 Portal**. The shared controller and Bluetooth audio handling was
also validated on **AYN Thor in Daikatana**; this game's Thor and external-controller
combinations still need physical testing.

## Installation

1. Download `UnrealGold-x.y.z.apk` from [Releases](https://github.com/tib-kpl/UnrealGold-Android/releases/latest)
   and install it.
2. Start **Unreal Gold** and grant **all files access**.
3. Either:
   - **Download the game**: pick a destination folder; a `UnrealGold` folder is created there.
     The installation media is about 677 MB. The launcher checks for at least 3 GiB of
     free space; keep additional internal space for the runtime, patch and private cache.
     Downloads continue with the screen off and can resume after interruption;
   - or **I already have the game**: select the existing game folder containing `System`,
     `Maps`, `Textures`, `Sounds` and `Music`.
4. On first launch, the launcher installs its Linux runtime and downloads the OldUnreal
   ARM64 patch. An Internet connection is needed for the initial download and installation.

To change the game folder later, **long-press the app icon** and choose
**Changer le dossier du jeu**.

### Gamepad controls

The controller is translated to keyboard and mouse input. **Mouse ON** moves the menu
pointer with the right stick; **Mouse OFF** aims in game. Use the compact, translucent button at the top center to switch modes. The label follows the selected game
language. SDL mouse capture reports mode changes, but the manual switch remains available
for menus that keep capture enabled.

In menus, R2 clicks, A sends Enter, B goes back and X sends Tab. Start also sends Escape. The D-pad moves between
controls (down: next, up: previous); left/right changes the selected value. The left stick
sends arrow keys. Touch input positions and clicks the pointer in Mouse ON mode.
**Select** opens the Android keyboard for the selected text field.

In Game mode:

| Button | Action |
|---|---|
| Left stick | Move (W/A/S/D) |
| Right stick | Aim |
| R2 | Fire / left mouse click |
| L2 | Secondary fire / right mouse click |
| A | Jump |
| B | Back in menus; no gameplay action |
| Start | Escape / menu |
| L1 / R1 | Previous / next weapon |
| L3 | Crouch |
| R3 | Best weapon |
| Select | Open Android keyboard |
| D-pad Up | Translator (F2) |
| D-pad Down | Objectives / hints (F3) |
| D-pad Left / Right | Arrow keys |
| X | Activate inventory item |
| Y | Scores |

The translator must have been picked up. Weapon cycling requires at least two available
weapons. These game controls are used in Mouse OFF mode.

### Launcher settings

The settings gear pauses the current session:

- **Retour au jeu** resumes the same session without relaunching the engine.
- **Redémarrer le jeu** restarts the engine to apply language or graphics changes.
- **Graphismes** offers automatic GPU selection, integrated Turnip/Zink, software rendering
  and 540p/720p/1080p. Android Turnip driver ZIP imports are not supported.
- **Afficher les FPS du moteur** toggles the upper-right counter. Visibility changes when
  returning to the running game; renderer and resolution changes apply at the next launch.
- **Configurer la manette** saves button mappings and right-stick axis choices per device.

### External controllers

Xbox, PlayStation (DualShock / DualSense), Switch-style and generic Android controllers
use Android's standard button positions over USB or Bluetooth. The configuration screen
shows Microsoft, Sony or Nintendo button legends when identified, and generic A/B/X/Y
labels otherwise. Right-stick Z/RZ and RX/RY layouts and device dead zones are handled.
Analog and digital trigger reports are merged to avoid duplicate actions; disconnecting
or reconfiguring a controller releases held actions. The Linux runtime does not open a
second copy of the physical controller. Odin 2 Portal mappings are preserved.

Xbox, DualSense and Switch controllers still need physical validation with this port.

### Saves, language and audio

Saves, cache and user settings live in the app's private home directory. The engine uses
`Unreal.ini` and `User.ini`; its `Save` and `Cache` folders link to persistent app storage.
Save/load was validated on the Odin 2 Portal. The engine uses the relative `../Save` path
so saved games can find their `index.ulk` files.

Use the same signing key for app updates to retain app data. Uninstalling the app removes
its private saves and settings.

The selected language applies on engine restart. Localized voices depend on the language
assets present in the game data; the APK does not bundle voice packs.

AudioTrack follows Android's selected media output (speakers, Bluetooth, wired or USB audio).
The bridge preserves unwritten PCM after partial writes and recreates the output if Android
invalidates it, while the engine keeps running. Pause/stop flush queued sound. Recovery and
pause/resume were tested by simulation; a real Bluetooth connect/disconnect transition was
validated in Daikatana on the Thor. Headset transitions in this game remain to be checked.

### Local multiplayer (LAN)

Connect both devices to the same Wi-Fi network. On the host, create a multiplayer game
and start the listen server. On the other device, open the LAN server list and select
the discovered game; no IP address needs to be entered. In UT2004, enable **Serveur LAN**
in the server rules and use **Ecoute** to host while playing.

The launcher enables Wi-Fi multicast reception while the engine runs and prepares Linux
hostname/DNS resolution from the Android network. Discovery and joining were tested between
an Odin 2 Portal and an AYN Thor: UT99 (DM-Agony), Unreal Gold (DmTerra), and UT2004
(DM-1on1-Albatross). A guest Wi-Fi network that isolates clients prevents LAN connections.
Internet server discovery and hosting depend on the game's master servers and router setup;
these two-console tests validate LAN play.

## How it works

```text
Android app (Java)
 +-- proot --> minimal Debian arm64 --> Xvfb (virtual X screen) --> Unreal Gold engine
 |                                       +-- OpenGL: Zink --> Vulkan Turnip --> Adreno (KGSL)
 |                                       +-- libutbridge.so (LD_PRELOAD): input, pause, FPS
 +-- displays the Xvfb framebuffer with OpenGL ES, scaled to the screen
 +-- sends controller/keyboard/touch input over a local socket to the engine bridge
 +-- plays sound: OpenAL --> ALSA --> FIFO --> Android AudioTrack
```

The installer follows the media layout used by
[OldUnreal's Linux installers](https://github.com/OldUnreal/FullGameInstallers/tree/master/Linux).
The Unreal Gold disc image is extracted with 7-Zip, then its InstallShield cabinets are
extracted with unshield inside the embedded Linux environment.

The engine sees game data through symbolic links, with patch files overlaid in the app's
private working directory. An existing source installation is preserved. The Xvfb system
cursor is hidden so only the game's menu pointer is visible.

## Repository layout

| Path | Content |
|---|---|
| `android/app/` | Android launcher, display, controller and audio bridges |
| `android/runtime/` | Linux runtime, Mesa build, native input bridge and installation scripts |
| `.github/workflows/release.yml` | APK build and GitHub release |
| `THIRD_PARTY.md` | Dependency notices and source information |

## Building

### With GitHub Actions

Every push to `main` builds the APK and publishes a release with version
`0.1.<build number>`. Mesa and the Linux runtime are built on native ARM64 GitHub runners.
The release includes the signed APK and a runtime package list.

**Signing** uses these repository secrets:

- `OPENUG_KEYSTORE_BASE64`
- `OPENUG_KEYSTORE_PASSWORD`
- `OPENUG_KEY_ALIAS`
- `OPENUG_KEY_PASSWORD`

Without signing secrets, the build uses a debug key. Keep the same release key for updates;
private keys and generated APKs/runtimes belong outside Git.

### Locally

Requirements: JDK 21, Android SDK (platform 36), Python 3 and Docker with ARM64 support
(native host or configured ARM64 emulation). From the repository root in a Linux shell:

```sh
# 1. Mesa Turnip + Zink -> android/runtime/out/turnip.tgz
docker run --rm -v "$PWD:/src" debian:trixie sh /src/android/runtime/build-mesa.sh

# 2. ARM64 Linux runtime -> android/runtime/out/rootfs.tgz
docker run --rm --platform linux/arm64 -v "$PWD:/src" debian:trixie sh /src/android/runtime/build-runtime.sh

# 3. proot (Termux packages) -> android/app/src/main/jniLibs/arm64-v8a/
python3 android/runtime/prepare-proot.py

# 4. APK
cd android
./gradlew assembleRelease
```

On Windows, use `gradlew.bat assembleRelease` for the APK step and set `JAVA_HOME` and
`ANDROID_HOME` to the installed JDK and Android SDK.

## Current limitations

- ARM64 Android devices only; Android 8.0 or newer.
- GPU acceleration requires compatible Adreno/KGSL hardware. Other devices use software
  rendering, which is slower.
- Menu mouse capture varies between screens; the manual Mouse ON/OFF switch remains useful.
- External Xbox, PlayStation and Switch controllers still need physical testing.

## Credits and licenses

- **Unreal Gold**: game content and trademarks belong to their respective owners, including
  Epic Games. This project is **neither affiliated with nor endorsed by** Epic Games or OldUnreal.
- **OldUnreal**: [227 patches](https://github.com/OldUnreal/Unreal-testing) and
  [official game installers](https://github.com/OldUnreal/FullGameInstallers). Engine and
  game files are downloaded from upstream sources and are not bundled in the APK.
- **proot** (GPL-2.0) and **libtalloc** (LGPL-3.0): [Termux](https://termux.dev) packages.
- **Linux runtime**: [Debian](https://www.debian.org) packages, Mesa, X.Org Xvfb, 7-Zip
  and unshield, each under its own license.
- See [THIRD_PARTY.md](THIRD_PARTY.md) for dependency notices and source access.
- The app icon and launcher illustration are original generated fan art inspired by the game.
