{ config, lib, ... }:
let
  cfg = config.my.services.grafana;
in
  with lib;
{
  options.my.services.grafana = {
    enable = mkEnableOption "Grafana LGTM stack";
  };

  config.services = mkIf cfg.enable {
    # opentelemetry-collector = {
    #   enable = true;
    #   settings = {
    #     # TODO Run locally first to ascertain correct settings for forwarding to grafana
    #   };
    # };
    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          enforce_domain = true;
          enable_gzip = true;
          domain = "127.0.0.1";
        };
        analytics.reporting_enabled = false;
      };
    };
    tempo = {
      enable = true;
      settings = {
        distributor.receivers.otlp.protocols.grpc.endpoint = "0.0.0.0:9337";
        server.http_listen_address = "127.0.0.1";
        server.http_listen_port = 3200;
        server.grpc_listen_port = 9094;
        storage.trace = {
          backend = "local";
          wal.path = "/tmp/tempo/wal";
          local.path = "/tmp/tempo/blocks";
        };
      };
    };
    loki = {
      enable = false; # TODO loki fails for some reason. Not sure what I'm missing
      configuration = {
        server = {
          http_listen_port = 3001;
          grpc_listen_port = 9097;
        };
        storage_config = {
          tsdb_shipper = {
            active_index_directory = "/tmp/lokidata/tsdb-index";
            cache_location = "/tmp/lokidata/tsdb-cache";
          };
        };
        compactor.working_directory = "/tmp/lokidata/compactor";
        schema_config.configs = [{
          from = "2020-01-01";
          index.period = "24h";
          index.prefix = "index_";
          schema = "v13";
          object_store = "filesystem";
          store = "tsdb";
        }];
      };
    };
    mimir = {
      enable = true;
      configuration = {
        ingester.ring.replication_factor = 1;
        memberlist.advertise_port = 7947;
        multitenancy_enabled = false; # connecting the datasource in grafana fails without this
        server = {
          http_listen_port = 3002;
          grpc_listen_port = 9096;
        };
      };
    };
  };
}

