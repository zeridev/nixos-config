{ lib, config, ... }:
let
  cfg = config.users.dezeekees;
in
{

  options = {
    users.dezeekees.enable = lib.mkEnableOption "the main user i use";
  };

  config = lib.mkIf cfg.enable {

    users.users.dezeekees = {
      isNormalUser = true;
      description = "dezeekees";
      extraGroups = [
        "networkmanager"
        "wheel"
        "music"
        "copyparty"
        "satisfactory"
      ];
    };

  };

}