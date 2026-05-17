{ config, lib, pkgs, ... }:
{
  options.my.features.sleep = lib.mkEnableOption "sleep/suspend configuration";

  config = lib.mkIf config.my.features.sleep {
    systemd.services.disable-wakeup = {
      description = "Disable all ACPI wake sources";
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      script = ''
        for device in $(${pkgs.gawk}/bin/awk '{if ($3 == "*enabled") print $1}' /proc/acpi/wakeup); do
          echo $device > /proc/acpi/wakeup
        done
      '';
      serviceConfig.Type = "oneshot";
    };

    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "ignore";
    };
  };
}
