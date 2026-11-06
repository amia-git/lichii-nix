{
  lib,
  stdenv,
  fetchTarball,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "lichii";
  version = "0.1.0-rc1";

  src = fetchTarball {
    url = "https://github.com/zortos293/Lichii/archive/b06d1818eeec9ab13f0df9822b58aef50a601483.tar.gz";
    sha256 = "+DCcZVtkwir8DE4Yx61ZHQIJA3PlDkZo+yJ0pxchtDU=";
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
    opus
    qt6.qtbase
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
    (lib.cmakeBool "YUZU_DOWNLOAD_TIME_ZONE_DATA" false)
    (lib.cmakeBool "CPMUTIL_FORCE_SYSTEM" true)
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
