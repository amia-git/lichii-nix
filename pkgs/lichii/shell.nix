{
  mkShell,
  pkgs,
  ...
}:

mkShell {
  packages = with pkgs; [
    cmake
    ninja
    pkg-config
    python3
    git
    jq
  ];
}
