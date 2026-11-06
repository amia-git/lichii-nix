{
  lib,
  stdenv,
  fetchzip,
  cmake,
  ninja,
  pkg-config,
  python3,
  git,
  jq,
  boost,
  catch2_3,
  cpp-jwt,
  cubeb,
  discord-rpc,
  enet,
  ffmpeg,
  fmt,
  gamemode,
  glslang,
  httplib,
  libGL,
  libgbm,
  libpulseaudio,
  libusb1,
  libxkbcommon,
  lz4,
  nlohmann_json,
  openssl,
  opus,
  qt6,
  qt6Packages,
  sdl3,
  spirv-headers,
  spirv-tools,
  udev,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
  vulkan-utility-libraries,
  wayland,
  xbyak,
  zlib,
  zstd,
}:

let
  # nixpkgs' opus.pc claims "Version: 0", so find_package(Opus 1.3 MODULE)
  # rejects it. Rewrite the field to the real version.
  opus' = opus.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      substituteInPlace $out/lib/pkgconfig/opus.pc \
        --replace-fail "Version: 0" "Version: ${old.version}"
    '';
  });

  # Sources CPM would otherwise clone at configure time. Upstream pins these
  # commits and forces them bundled (zbic is DOWNLOAD_ONLY, zstd must match the
  # bundled encoder), so they are prefetched and handed over via
  # <name>_CUSTOM_DIR.
  cpmSource = { owner, repo, rev, hash, host ? "github.com" }:
    fetchzip {
      url = "https://${host}/${owner}/${repo}/archive/${rev}.tar.gz";
      inherit hash;
    };

  # Packaged as a release artifact rather than a GitHub tag.
  tzdb = fetchzip {
    url = "https://git.eden-emu.dev/eden-emu/tzdb_to_nx/releases/download/230326/230326.tar.gz";
    hash = "sha256-d9pC/IcarSjvab+c2kMadCBc+1KkAoe2WG1K9+YtSvo=";
  };

  frozen = cpmSource {
    owner = "serge-sans-paille";
    repo = "frozen";
    rev = "61dce5ae18";
    hash = "sha256-zIczBSRDWjX9hcmYWYkbWY3NAAQwQtKhMTeHlYp4BKk=";
  };

  sirit = cpmSource {
    owner = "eden-emulator";
    repo = "sirit";
    rev = "v1.0.5";
    hash = "sha256-T4f1C33rh8KEXPyxPiIbdDUQLGT3ufTIt4XmgSsLRpA=";
  };

  simpleini = cpmSource {
    owner = "brofield";
    repo = "simpleini";
    rev = "v4.25";
    hash = "sha256-1JTVjMfEuWqlyYAm4Er6HPjrP2Tnt0ntai8oVvIEOu0=";
  };

  zbic = cpmSource {
    owner = "kinnay";
    repo = "zbic";
    rev = "11b08f2712264bbed731545085cbd9702096ceb7";
    hash = "sha256-pHvxa1gkUvQo6mUgmLWtj1kcu01BLdGmttZyb8ZAj/o=";
  };

  zstd' = cpmSource {
    owner = "facebook";
    repo = "zstd";
    rev = "33618c8";
    hash = "sha256-UP99PUq8N+fmU972Jxim4f9u//T+4hRW+wuTZzWg3uI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lichii";
  version = "0.1.0-rc1";

  src = fetchzip {
    url = "https://github.com/zortos293/Lichii/archive/b06d1818eeec9ab13f0df9822b58aef50a601483.tar.gz";
    hash = "sha256-YWA4Jr0zHS0jimh/ou2ncXSiHf7JjOig2ub8YFf82v0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    git
    jq
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    catch2_3
    cpp-jwt
    cubeb
    discord-rpc
    enet
    ffmpeg
    fmt
    gamemode
    glslang
    httplib
    libGL
    libgbm
    libpulseaudio
    libusb1
    libxkbcommon
    lz4
    nlohmann_json
    openssl
    opus'
    qt6.qtbase
    qt6.qtcharts
    qt6.qtmultimedia
    qt6.qtwayland
    qt6.qt5compat
    qt6Packages.quazip
    sdl3
    spirv-headers
    spirv-tools
    udev
    vulkan-headers
    vulkan-loader
    vulkan-memory-allocator
    vulkan-utility-libraries
    wayland
    xbyak
    zlib
    zstd
  ];

  # Keep the patched opus.pc ahead of copies pulled in by propagated deps.
  preConfigure = ''
    export PKG_CONFIG_PATH="${opus'}/lib/pkgconfig:''${PKG_CONFIG_PATH-}"
  '';

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT" true)
    (lib.cmakeBool "YUZU_USE_BUNDLED_QT" false)
    (lib.cmakeBool "YUZU_CMD" true)
    (lib.cmakeBool "YUZU_ROOM" false)
    (lib.cmakeBool "YUZU_TESTS" false)
    (lib.cmakeBool "ENABLE_WERROR" false)
    (lib.cmakeBool "YUZU_USE_BUNDLED_SDL3" false)
    (lib.cmakeBool "YUZU_USE_BUNDLED_FFMPEG" false)
    (lib.cmakeBool "YUZU_USE_EXTERNAL_FFMPEG" false)
    (lib.cmakeBool "YUZU_USE_BUNDLED_OPENSSL" false)
    (lib.cmakeBool "ENABLE_UPDATE_CHECKER" false)
    (lib.cmakeBool "USE_DISCORD_PRESENCE" false)
    (lib.cmakeBool "ENABLE_LSFG" false)
    (lib.cmakeBool "ENABLE_RESHADE" false)
    (lib.cmakeBool "YUZU_INSTALL_UDEV_RULES" false)
    (lib.cmakeBool "YUZU_DOWNLOAD_TIME_ZONE_DATA" true)
    (lib.cmakeBool "CPMUTIL_FORCE_SYSTEM" true)
    (lib.cmakeBool "zbic_FORCE_BUNDLED" true)
    (lib.cmakeFeature "zbic_CUSTOM_DIR" "${zbic}")
    (lib.cmakeBool "zstd_FORCE_BUNDLED" true)
    (lib.cmakeFeature "zstd_CUSTOM_DIR" "${zstd'}")
    (lib.cmakeBool "frozen_FORCE_BUNDLED" true)
    (lib.cmakeFeature "frozen_CUSTOM_DIR" "${frozen}")
    (lib.cmakeBool "SimpleIni_FORCE_BUNDLED" true)
    (lib.cmakeFeature "SimpleIni_CUSTOM_DIR" "${simpleini}")
    (lib.cmakeBool "sirit_FORCE_BUNDLED" true)
    (lib.cmakeFeature "sirit_CUSTOM_DIR" "${sirit}")
    (lib.cmakeBool "nx_tzdb_FORCE_BUNDLED" true)
    (lib.cmakeFeature "nx_tzdb_CUSTOM_DIR" "${tzdb}")
  ];

  meta = {
    description = "Experimental Nintendo Switch and Switch 2 emulator";
    homepage = "https://github.com/zortos293/Lichii";
    license = lib.licenses.gpl3Plus;
    mainProgram = "lichii";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
