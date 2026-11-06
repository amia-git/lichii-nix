{ pkgs }:

pkgs.mkShell {
  inputsFrom = [ (pkgs.callPackage ./default.nix { }) ];
  packages = with pkgs; [
    cmake
    ninja
    pkg-config
    python3
    git
    jq
    ccache
  ];
}
