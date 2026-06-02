# modules/terraria.nix
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.displayManager.sddm.terraria;
  defaults = {
    background = "ter1.png";
    background_mode = "random";
    background_index = 5;
    mainColor = "#cceeff";
    accentColor = "#ffcc00";
    containerColor = "#1a1a4a";
    fontName = "Andy Bold";
    fontSize = 14;
  };

  merged =
    defaults
    // {
      background_mode = cfg.backgroundMode;
      background_index = cfg.backgroundIndex;
    };
  themeConf = lib.generators.toINI {} {
    General = merged;
  };
in {
  options.services.displayManager.sddm.terraria = {
    enable = lib.mkEnableOption "Enable Terraria SDDM theme options";

    backgroundMode = lib.mkOption {
      type = lib.types.enum ["time" "random" "static"];
      default = "random";
    };

    backgroundIndex = lib.mkOption {
      type = lib.types.int;
      default = 1;
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      theme = "terraria";
      # package = pkgs.callPackage ../pkgs/terraria {
      #   inherit themeConf;
      # };
      extraPackages = with pkgs; [
        (pkgs.callPackage ../pkgs/terraria {inherit themeConf;})
        qt6.qtdeclarative
        qt6.qt5compat
        qt6.qtsvg
        qt6.qtmultimedia
        qt6.qtmultimedia-ffmpeg
      ];
    };
  };
}
