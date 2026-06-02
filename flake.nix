{
  description = "SDDM Themes with NixOS module (Terraria example)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    lib = nixpkgs.lib;
  in {
    # 🔧 Package output
    packages.x86_64-linux = {
      terraria-theme = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/terraria {};
    };

    # 🧩 NixOS module
    nixosModules.default = import ./modules/sddm-terraria.nix;

    # Optional: dev shell
    devShells.x86_64-linux.default =
      nixpkgs.legacyPackages.x86_64-linux.mkShell {
        packages = [ nixpkgs.legacyPackages.x86_64-linux.nixfmt ];
      };
  };
}
