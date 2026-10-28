{ config, lib, ... }:
{
  options.my.features.fleet = lib.mkEnableOption "Fleet osquery agent";

  config = lib.mkIf config.my.features.fleet {
    sops.secrets = {
      fleet-enroll-secret = {};
      fleet-server-certs = {};
    };

    services.osquery = {
      enable = true;
      flags = {
        # Server
        tls_hostname = "fleet.zrch.cloud";
        tls_server_certs = config.sops.secrets.fleet-server-certs.path;
        # Enrollment
        host_identifier = "instance";
        enroll_secret_path = config.sops.secrets.fleet-enroll-secret.path;
        enroll_tls_endpoint = "/api/osquery/enroll";
        # Configuration
        config_plugin = "tls";
        config_tls_endpoint = "/api/v1/osquery/config";
        config_refresh = "10";
        # Live query
        disable_distributed = "false";
        distributed_plugin = "tls";
        distributed_interval = "10";
        distributed_tls_max_attempts = "3";
        distributed_tls_read_endpoint = "/api/v1/osquery/distributed/read";
        distributed_tls_write_endpoint = "/api/v1/osquery/distributed/write";
        # Logging
        logger_plugin = "tls";
        logger_tls_endpoint = "/api/v1/osquery/log";
        logger_tls_period = "10";
        # File carving
        disable_carver = "false";
        carver_start_endpoint = "/api/v1/osquery/carve/begin";
        carver_continue_endpoint = "/api/v1/osquery/carve/block";
        carver_block_size = "8000000";
      };
    };
  };
}
