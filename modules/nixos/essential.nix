{ lib, config, ... }:
with lib;
let
  cfg = config.environment.nix-persist.essential;
  path = (config.environment.nix-persist) path;
in {
  options.environment.nix-persist.essential.enable =
    mkEnableOption "Essential files into persistent storage";

  config = mkIf cfg.enable {
    environment.persistence.${path} = {
      # Clean kernel debug messages
      systemd.tmpfiles.rules =
        [ "d /var/lib/systemd/pstore 0755 root root 14d" ];
      directories = [
        # System logs
        {
          directory = "/var/log";
          user = "root";
          group = "root";
          mode = "0755";
        }
        # NixOS stuff (idk)
        {
          directory = "/var/lib/nixos";
          user = "root";
          group = "root";
          mode = "0755";
        }
        # SystemD stuff
        {
          directory = "/var/lib/systemd";
          user = "root";
          group = "root";
          mode = "0755";
        }
        {
          directory = "/var/tmp";
          user = "root";
          group = "root";
          mode = "1777";
        }
        {
          directory = "/var/spool";
          user = "root";
          group = "root";
          mode = "0777";
        }
      ];
      files = [ "/etc/machine-id" ];
    };
  };
}
