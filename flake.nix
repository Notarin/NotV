{
  description = "A flake for various packaged games, currently only containing VotV";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux"];
    buildAllSystems = output: builtins.foldl' nixpkgs.lib.recursiveUpdate {} (builtins.map output systems);
  in (buildAllSystems (
    system: let
      pkgs = nixpkgs.legacyPackages.${system};
      root.formatter.${system} = pkgs.callPackage ./formatter.nix {};
      votv = import ./VotV {inherit pkgs self;};
    in
      builtins.foldl' nixpkgs.lib.recursiveUpdate {} [root votv]
  ));
}
