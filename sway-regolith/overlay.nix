self: super: {
  libtrawldb = import ./libtrawldb/default.nix { inherit (super) pkgs; };
}
