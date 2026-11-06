# lichii-nix

[![Build release and publish to Cachix](https://github.com/amia-git/lichii-nix/actions/workflows/release.yml/badge.svg)](https://github.com/amia-git/lichii-nix/actions/workflows/release.yml)

Nix packaging for [Lichii](https://github.com/zortos293/Lichii), a Nintendo Switch 2
emulator.

## NixOS

Add this flake to your system flake's inputs:

```nix
inputs.lichii-nix.url = "github:amia-git/lichii-nix";
```

Import the module in your NixOS configuration and enable Lichii:

```nix
{ inputs, ... }:
{
  imports = [ inputs.lichii-nix.nixosModules.default ];
  programs.lichii.enable = true;
}
```

Pass `inputs` to your NixOS modules with `specialArgs = { inherit inputs; };`
in your `nixpkgs.lib.nixosSystem` call, or import the module directly in that
call's `modules` list.

Importing the module automatically adds `https://amia-git.cachix.org` and its
public signing key to Nix's settings, even with `programs.lichii.enable = false`.
Existing caches and signing keys are preserved. Enabling the program installs
the package from this flake; use `programs.lichii.package` to override it.

## Binary cache

Release builds for `x86_64-linux` are published to
[amia-git.cachix.org](https://amia-git.cachix.org). Enable the cache to avoid
compiling available builds locally, then run Lichii:

```sh
cachix use amia-git
nix run github:amia-git/lichii-nix
```
