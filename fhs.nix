{ pkgs ? import <nixpkgs> {} }:

let
  regolith-packages = import ./packages { inherit pkgs; };
  
  # Get all packages including their dependencies
  regolith-pkgs = [
    regolith-packages.ilia
    regolith-packages.regolith-powerd
    regolith-packages.regolith-displayd
    regolith-packages.regolith-inputd
    regolith-packages.regolith-ftue
    regolith-packages.xrescat
    regolith-packages.rofication
    regolith-packages.remontoire
    regolith-packages.trawl
    regolith-packages.i3xrocks
    regolith-packages.libtrawlb
    regolith-packages.regolith-look-extra
    regolith-packages.i3status-rs
    regolith-packages.sway-regolith
    regolith-packages.regolith-session
    regolith-packages.regolith-look-default
    regolith-packages.regolith-wm-config
    regolith-packages.i3-swap-focus
    regolith-packages.regolith-systemd-units
    regolith-packages.regolith-i3status-config
  ];

  # Collect all build inputs recursively
  all-inputs = builtins.concatMap 
    (p: if builtins.hasAttr "buildInputs" p then p.buildInputs ++ [p] else [p]) 
    regolith-pkgs;
in
pkgs.buildFHSEnv {
  name = "regolith-environment";
  
  targetPkgs = pkgs: with pkgs; [
    # Basic system utilities
    mate.mate-polkit
    bash
    coreutils
    gtk3
    glib
    

    #gnome services
    gnome-session
    gnome-settings-daemon
    gnome-shell
    gnome-control-center
    gnome-keyring
    gnome-terminal
    gnome-control-center
    
    # Add dbus and window manager related packages
    dbus
    xorg.xmodmap
    wlr-randr
    
    # Add missing dependencies
    networkmanager
    networkmanagerapplet
    systemd
    # i3
    kanshi
    wl-clipboard
    sway-audio-idle-inhibit
    avizo
    
    # Add polkit and related packages
    polkit
    polkit_gnome
    mate.mate-polkit
    
    # Python dependencies
    (python3.withPackages (ps: with ps; [
      i3ipc
    ]))
  ];

  multiPkgs = pkgs: all-inputs;

  extraOutputsToInstall = [ "usr" "etc" "lib" "share" ];

  # Add environment variables to handle key binding conflicts
  profile = ''
    export REGOLITH_PATH=/usr/share/regolith
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share/regolith
    export XDG_CONFIG_HOME=$HOME/.config
    export GNOME_SHELL_SESSION_MODE=regolith

    # Create systemd user directory if it doesn't exist
    mkdir -p $HOME/.config/systemd/user

    # Link systemd services
    ln -sf /usr/lib/systemd/user/regolith-wayland.target $HOME/.config/systemd/user/
    ln -sf /usr/lib/systemd/user/regolith-init-kanshi.service $HOME/.config/systemd/user/
    ln -sf /usr/lib/systemd/user/regolith-init-displayd.service $HOME/.config/systemd/user/
    ln -sf /usr/lib/systemd/user/regolith-init-powerd.service $HOME/.config/systemd/user/
    ln -sf /usr/lib/systemd/user/regolith-init-inputd.service $HOME/.config/systemd/user/

    # Enable the services
    systemctl --user daemon-reload
    systemctl --user enable regolith-wayland.target
    systemctl --user enable regolith-init-kanshi.service
    systemctl --user enable regolith-init-displayd.service
    systemctl --user enable regolith-init-powerd.service
    systemctl --user enable regolith-init-inputd.service
  '';

  runScript = "${pkgs.fish}/bin/fish";
} 