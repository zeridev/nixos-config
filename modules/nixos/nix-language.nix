{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    nixLanguage.enable = lib.mkEnableOption "Enables nix lsp and formatter";
  };

  config = lib.mkIf config.nixLanguage.enable {
    environment.systemPackages = with pkgs; [
      nixd
      nixfmt
    ];
    programs.nix-ld.enable = true;
  };

}
