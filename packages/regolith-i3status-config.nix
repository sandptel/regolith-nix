{ stdenv }:

stdenv.mkDerivation {
  name = "regolith-i3status-config";
  
  phases = [ "installPhase" ];
  
  installPhase = ''
    mkdir -p $out/share/regolith/i3status-rust
    
    cat > $out/share/regolith/i3status-rust/config.toml <<EOF
    theme = "native"
    icons = "awesome"
    
    [[block]]
    block = "cpu"
    interval = 1
    
    [[block]]
    block = "memory"
    display_type = "memory"
    format_mem = "{mem_used_percents}"
    
    [[block]]
    block = "time"
    interval = 60
    format = "%a %d/%m %R"
    EOF
  '';
} 