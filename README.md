# dotfilesv2

My dotfiles, as managed by GNU stow.

### Towards Nix

Recently I switched to NixOS (from Arch) and I'm gradually learning how
to control all of my dots through NixOS and
[home-manager](https://github.com/nix-community/home-manager). If all goes
well, many of these dots will be deleted and put under the control of
Nix.

### Stow

E.g.

```
$ git clone git@github.com:the-mikedavis/dotfilesv2.git
$ cd dotfilesv2
$ stow i3
```

will symlink the i3 configuration into `~/.config/i3/config`.
