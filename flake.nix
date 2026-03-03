{
  description = "myvpn flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      nixpkgs,
      systems,
      self,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      forEachPkgs = f: lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forEachPkgs (pkgs: {

        default = pkgs.callPackage ./nix { inherit self; };
        client = pkgs.callPackage ./nix { inherit self; subPackage = "client"; };
        server = pkgs.callPackage ./nix {inherit self; subPackage = "server"; };

      });
    };
}
