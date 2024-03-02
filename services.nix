{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.release-go;

  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yaml" cfg.settings;
in
{
  options.services.release-go = {
    enable = mkEnableOption (lib.mdDoc "release-go");

    settings = mkOption {
      type = format.type;
      default = { };
      description = lib.mdDoc ''
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.release-go = {
      description = "";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.release-go}/bin/release-go --config ${configFile}";
        Restart = "on-failure";

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };
    };
  };
}