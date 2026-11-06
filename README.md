# lichii-nix

Nix packaging for [Lichii](https://github.com/zortos293/Lichii), a Nintendo Switch 2
emulator.

## Binary cache

Release builds for `x86_64-linux` are published to
[amia-git.cachix.org](https://amia-git.cachix.org). Enable the cache to avoid
compiling available builds locally, then run Lichii:

```sh
cachix use amia-git
nix run github:amia-git/lichii-nix
```
