# pkgs/terraria/default.nix
{
  themeConf ? "",
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "sddm-terraria-theme";
  version = "1.0";

  src = ../../themes/terraria;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/terraria
    cp -r . $out/share/sddm/themes/terraria

    if [ -n "${themeConf}" ]; then
    cat > $out/share/sddm/themes/terraria/theme.conf <<'EOF'
      ${themeConf}
    EOF
    fi
  '';
}
