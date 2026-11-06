{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.lichii;
in
{
  options.programs.lichii = {
    enable = lib.mkEnableOption "Lichii, the Nintendo Switch and Switch 2 emulator";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.lichii;
      defaultText = lib.literalExpression "lichii-nix.packages.\${pkgs.stdenv.hostPlatform.system}.lichii";
      description = "The Lichii package to install.";
    };
  };

  config = {
    nix.settings = {
      substituters = [ "https://amia-git.cachix.org" ];
      trusted-public-keys = [
        "amia-git.cachix.org-1:ZGu9XflXEYq5XxkO5CKh+ZGfbgRtEylrBP98cwkXFfE="
      ];
    };

    environment.systemPackages = lib.mkIf cfg.enable [ cfg.package ];
  };
}
