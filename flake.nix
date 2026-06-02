{
  description = "SDDM Themes with NixOS module (Terraria example)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    # 🔧 Package output
    packages.x86_64-linux = {
      terraria-theme = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/terraria {};
    };

    # 🧩 NixOS module
    nixosModules.default = import ./modules/terraria.nix;

    # Optional: dev shell
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        kdePackages.sddm
        qt6.qtdeclarative
        qt6.qt5compat
        qt6.qtsvg
        qt6.qtmultimedia
      ];

      shellHook = ''
        export QML2_IMPORT_PATH="${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml:$QML2_IMPORT_PATH"
        export QML_IMPORT_PATH="$QML2_IMPORT_PATH"

        echo "qylock dev shell (clean)"
        echo "run:"
        echo "  sddm-greeter-qt6 --test-mode --theme result/share/sddm/themes/terraria"
      '';
    };
  };
}
