{
  config = {
    systemd.services.disable-wakeup = {
      description = "Disable all ACPI wake sources";
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      script = ''
        for device in $(awk '{if ($3 == "*enabled") print $1}' /proc/acpi/wakeup); do
          echo $device > /proc/acpi/wakeup
        done
      '';
      serviceConfig.Type = "oneshot";
    };

    services.logind.lidSwitch = "ignore";
    services.logind.lidSwitchDocked = "ignore";
    services.logind.lidSwitchExternalPower = "ignore";
  };
}
