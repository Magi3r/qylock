{
  description = "qylock SDDM Themes as NixOS module";

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
      genshin-theme = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/genshin {};
    };

    # 🧩 NixOS module
    nixosModules = {
      terraria = import ./modules/terraria.nix;
      genshin = import ./modules/genshin.nix;

      default = {
        imports = [
          ./modules/terraria.nix
          ./modules/genshin.nix
        ];
      };
    };
    # Optional: dev shell
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        kdePackages.sddm
        qt6.qtdeclarative
        qt6.qt5compat
        qt6.qtsvg
        qt6.qtmultimedia

        pipewire
        ffmpeg
      ];

      shellHook = ''
        export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [pkgs.pipewire]}"
        export QT_PLUGIN_PATH="${pkgs.qt6.qtmultimedia}/lib/qt-6/plugins:$QT_PLUGIN_PATH"
        export QML2_IMPORT_PATH="${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml:${pkgs.qt6.qtsvg}/lib/qt-6/qml:${pkgs.qt6.qtmultimedia}/lib/qt-6/qml:$QML2_IMPORT_PATH"
        export QML_IMPORT_PATH="$QML2_IMPORT_PATH"

        echo "qylock dev shell (clean)"
        echo "run:"
        echo "  sddm-greeter-qt6 --test-mode --theme result/share/sddm/themes/terraria"
      '';
    };
  };
}
