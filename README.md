# Building Packages 
Installing Nix
```
sh <(curl -L https://nixos.org/nix/install) --no-daemon
 . ~/.nix-profile/etc/profile.d/nix.sh
export NIX_CONFIG="experimental-features = nix-command flakes"
```

To create a development shell with the following packages..

```nix develop github:sandptel/regolith-nix```

