# pkgs/genshin/default.nix
{
  themeConf ? "",
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "sddm-genshin-theme";
  version = "1.0";

  src = ../../themes/Genshin;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/genshin
    cp -r . $out/share/sddm/themes/genshin

    if [ -n "${themeConf}" ]; then
    cat > $out/share/sddm/themes/genshin/theme.conf <<'EOF'
      ${themeConf}
    EOF
    fi
  '';
}
