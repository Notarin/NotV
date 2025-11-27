{
  # Upstream treefmt-nix, used for its wrapper/script/formatter builder
  treefmt-nix ?
    import (builtins.fetchGit {
      url = "https://github.com/numtide/treefmt-nix";
      rev = "5b4ee75aeefd1e2d5a1cc43cf6ba65eba75e83e4";
    }),
  # Dependencies the wrapper builder needs
  lib,
  writeShellScriptBin,
  formats,
  treefmt,
  alejandra,
}:
treefmt-nix.mkWrapper {
  inherit
    lib
    writeShellScriptBin
    treefmt
    formats
    alejandra
    ;
} {
  programs = {
    alejandra.enable = true;
  };
}
