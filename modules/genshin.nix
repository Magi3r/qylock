# modules/genshin.nix
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.displayManager.sddm.genshin;
  defaults = {
    background = "day.png";
    background_mode = "time";
    background_index = 2;
    fontName = "zhcn";
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
  options.services.displayManager.sddm.genshin = {
    enable = lib.mkEnableOption "Enable Genshin SDDM theme options";

    backgroundMode = lib.mkOption {
      type = lib.types.enum ["time" "random" "static"];
      default = "time";
    };

    backgroundIndex = lib.mkOption {
      type = lib.types.int;
      default = 1;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.callPackage ../pkgs/genshin {inherit themeConf;})
    ];
    services.displayManager.sddm = {
      theme = "genshin";
      # package = pkgs.callPackage ../pkgs/genshin {
      #   inherit themeConf;
      # };
      extraPackages = with pkgs; [
        qt6.qtdeclarative
        qt6.qt5compat
        qt6.qtsvg
        qt6.qtmultimedia
        ffmpeg
      ];
    };
  };
}
