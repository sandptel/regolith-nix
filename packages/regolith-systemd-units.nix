{ stdenv }:

stdenv.mkDerivation {
  name = "regolith-systemd-units";
  
  phases = [ "installPhase" ];
  
  installPhase = ''
    mkdir -p $out/lib/systemd/user
    
    # Create regolith-wayland.target
    cat > $out/lib/systemd/user/regolith-wayland.target <<EOF
    [Unit]
    Description=Regolith Wayland Session
    BindsTo=graphical-session.target
    EOF
    
    # Create regolith-init-kanshi.service
    cat > $out/lib/systemd/user/regolith-init-kanshi.service <<EOF
    [Unit]
    Description=Regolith Kanshi Service
    PartOf=graphical-session.target
    
    [Service]
    Type=simple
    ExecStart=/usr/bin/kanshi
    
    [Install]
    WantedBy=regolith-wayland.target
    EOF
  '';
} 