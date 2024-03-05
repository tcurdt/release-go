{ self, ... }: {config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.release-go;

  # format = pkgs.formats.yaml { };
  # configFile = format.generate "config.yaml" cfg.settings;

  port = cfg.port;

in
{
  options.services.release-go = {
    enable = mkEnableOption "service enable";

    port = mkOption {
      type = types.port;
      default = 2000;
      description = "port to listen on";
    };

    # settings = mkOption {
    #   type = format.type;
    #   default = { };
    #   description = "";
    # };

  };

  config = mkIf cfg.enable {
    systemd.services.release-go = {
      description = "";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${self.packages.${pkgs.system}.default}/bin/release-go -port ${port}";
        # ExecStart = "${self.packages.${pkgs.system}.default}/bin/release-go --config ${configFile}";
        Restart = "on-failure";

        # AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        # CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };
    };
  };
}
