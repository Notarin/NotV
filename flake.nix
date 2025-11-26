{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      systems = [ "x86_64-linux" ];
      buildEachSystem = output: builtins.map (system: output system) systems;
      buildAllSystems =
        output:
        (builtins.foldl' (acc: elem: nixpkgs.lib.recursiveUpdate acc elem) { } (buildEachSystem output));
    in
    (buildAllSystems (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages.${system} = {
          default = self.packages.${system}.votv-wine-wayland;
          votv-wine-wayland = pkgs.callPackage ./package.nix { wine = pkgs.wineWow64Packages.waylandFull; };
          votv-wine64 = pkgs.callPackage ./package.nix { wine = pkgs.wine64; };
          votv-wine = pkgs.callPackage ./package.nix { wine = pkgs.wine; };
        };
        apps.${system} = {
          default = self.apps.${system}.votv-wine-wayland;
          votv-wine-wayland = {
            type = "app";
            program = "${pkgs.lib.getExe self.packages.${system}.votv-wine-wayland}";
            meta.description = "An early-access indie horror simulation video game";
          };
          votv-wine64 = {
            type = "app";
            program = "${pkgs.lib.getExe self.packages.${system}.votv-wine64}";
            meta.description = "An early-access indie horror simulation video game";
          };
          votv-wine = {
            type = "app";
            program = "${pkgs.lib.getExe self.packages.${system}.votv-wine}";
            meta.description = "An early-access indie horror simulation video game";
          };
        };
        formatter.${system} = pkgs.nixfmt-tree;
      }
    ));
}
