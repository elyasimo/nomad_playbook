job "elastic-agent" {
  datacenters = ["dum-seclab"]
  type = "service"

  group "elastic-agent" {
    count = 3

    network {
      # Ports for the various inputs
      port "fortinet_fortigate" {
        static = 7010
      }
      port "f5_bigip" {
        static = 9010
      }
      port "checkpoint" {
        static = 6010
      }
      port "proxysg_main" {
        static = 8011
      }
      port "fortinet_fortiproxy" {
        static = 7011
      }
      port "proxysg_ssl" {
        static = 8010
      }
      port "proxysg_system" {
        static = 8012
      }
      port "fortinet_fortimanager" {
        static = 7012
      }
    }

    task "elastic-agent" {
      driver = "docker"

      config {
        image = "docker.elastic.co/beats/elastic-agent:8.12.1"
        ports = [
          "fortinet_fortigate",
          "f5_bigip",
          "checkpoint",
          "proxysg_main",
          "fortinet_fortiproxy",
          "proxysg_ssl",
          "proxysg_system",
          "fortinet_fortimanager"
        ]

        # Run in host network mode to allow direct access to ports
        network_mode = "host"

        # Mount the configuration file
        volumes = [
          "local/elastic-agent.yml:/usr/share/elastic-agent/elastic-agent.yml"
        ]
      }

      # Embed the configuration directly instead of using Consul KV
      template {
        data = <<EOH
outputs:
  default:
    type: logstash
    hosts: ["138.188.154.108:5047"]
inputs:
  - id: tcp-fortinet_fortigate-25d31e90-22d0-4421-81ed-33c764c32908
    name: fortinet_fortigate
    revision: 2
    type: tcp
    use_output: default
    meta:
      package:
        name: fortinet_fortigate
        version: 1.31.0
    data_stream:
      namespace: fortinet
    package_policy_id: 25d31e90-22d0-4421-81ed-33c764c32908
    streams:
      - id: tcp-fortinet_fortigate.log-25d31e90-22d0-4421-81ed-33c764c32908
        data_stream:
          dataset: fortinet_fortigate.log
          type: logs
        host: '0.0.0.0:7010'
        network: tcp4
        tags:
          - preserve_original_event
          - fortinet-fortigate
          - fortinet-firewall
          - forwarded
        publisher_pipeline.disable_host: true
        ssl: null
        processors:
          - add_fields:
              target: _temp
              fields:
                internal_networks:
                  - private
        framing: rfc6587
  - id: http_endpoint-F5 BIG-IP-a0b62e63-7f70-42b1-83f0-9cf23be475a3
    name: f5_bigip-1
    revision: 2
    type: http_endpoint
    use_output: default
    meta:
      package:
        name: f5_bigip
        version: 1.22.0
    data_stream:
      namespace: f5
    package_policy_id: a0b62e63-7f70-42b1-83f0-9cf23be475a3
    streams:
      - id: http_endpoint-f5_bigip.log-a0b62e63-7f70-42b1-83f0-9cf23be475a3
        data_stream:
          dataset: f5_bigip.log
          type: logs
        listen_address: 0.0.0.0
        listen_port: 9010
        url: /
        preserve_original_event: true
        tags:
          - preserve_original_event
          - forwarded
          - f5_bigip-log
        publisher_pipeline.disable_host: true
        ssl: null
  - id: tcp-checkpoint-3daa7424-12db-4626-894c-7adacde824a7
    name: checkpoint
    revision: 2
    type: tcp
    use_output: default
    meta:
      package:
        name: checkpoint
        version: 1.39.0
    data_stream:
      namespace: checkpoint
    package_policy_id: 3daa7424-12db-4626-894c-7adacde824a7
    streams:
      - id: tcp-checkpoint.firewall-3daa7424-12db-4626-894c-7adacde824a7
        data_stream:
          dataset: checkpoint.firewall
          type: logs
        host: '0.0.0.0:6010'
        network: tcp4
        tags:
          - preserve_original_event
          - forwarded
        publisher_pipeline.disable_host: true
        ssl: null
        fields_under_root: true
        fields:
          _conf:
            tz_offset: UTC
        processors:
          - add_locale: null
  - id: tcp-proxysg-access-logs-3800c02e-41a6-4bff-95a8-cc5b347a12d2
    name: proxysg-main
    revision: 2
    type: tcp
    use_output: default
    meta:
      package:
        name: proxysg
        version: 0.5.1
    data_stream:
      namespace: broadcom
    package_policy_id: 3800c02e-41a6-4bff-95a8-cc5b347a12d2
    streams:
      - id: tcp-proxysg.log-3800c02e-41a6-4bff-95a8-cc5b347a12d2
        data_stream:
          dataset: proxysg.log
          type: logs
        host: '0.0.0.0:8011'
        network: tcp4
        tags:
          - preserve_original_event
          - forwarded
          - proxysg-main
        publisher_pipeline.disable_host: true
        ssl: null
        fields: null
        processors:
          - add_fields:
              target: _temp_
              fields:
                _conf: bcreportermain_v1
          - add_locale: null
  - id: tcp-fortinet_fortiproxy-c474462b-3940-4c3d-a494-e1bfa00456a3
    name: fortinet_fortiproxy
    revision: 2
    type: tcp
    use_output: default
    meta:
      package:
        name: fortinet_fortiproxy
        version: 1.2.0
    data_stream:
      namespace: fortinet
    package_policy_id: c474462b-3940-4c3d-a494-e1bfa00456a3
    streams:
      - id: tcp-fortinet_fortiproxy.log-c474462b-3940-4c3d-a494-e1bfa00456a3
        data_stream:
          dataset: fortinet_fortiproxy.log
          type: logs
        host: '0.0.0.0:7011'
        network: tcp4
        tags:
          - preserve_original_event
          - fortinet-fortiproxy
          - forwarded
        publisher_pipeline.disable_host: true
        ssl: null
        framing: rfc6587
  - id: tcp-proxysg-access-logs-7b62b29a-29f2-431d-b744-7bd3f60b93f7
    name: proxysg-ssl
    revision: 2
    type: tcp
    use_output: default
    meta:
      package:
        name: proxysg
        version: 0.5.1
    data_stream:
      namespace: broadcom
    package_policy_id: 7b62b29a-29f2-431d-b744-7bd3f60b93f7
    streams:
      - id: tcp-proxysg.log-7b62b29a-29f2-431d-b744-7bd3f60b93f7
        data_stream:
          dataset: proxysg.log
          type: logs
        host: '0.0.0.0:8010'
        network: tcp4
        tags:
          - preserve_original_event
          - forwarded
          - proxysg-ssl
        publisher_pipeline.disable_host: true
        ssl: null
        fields: null
        processors:
          - add_fields:
              target: _temp_
              fields:
                _conf: bcreporterssl_v1
          - add_locale: null
  - id: tcp-proxysg-access-logs-8a619c4c-c3e7-4f2e-8f68-8552a7af57bc
    name: proxysg-system
    revision: 3
    type: tcp
    use_output: default
    meta:
      package:
        name: proxysg
        version: 0.5.1
    data_stream:
      namespace: broadcom
    package_policy_id: 8a619c4c-c3e7-4f2e-8f68-8552a7af57bc
    streams:
      - id: tcp-proxysg.log-8a619c4c-c3e7-4f2e-8f68-8552a7af57bc
        data_stream:
          dataset: proxysg.log
          type: logs
        host: '0.0.0.0:8012'
        network: tcp4
        tags:
          - preserve_original_event
          - forwarded
          - proxysg-system
        publisher_pipeline.disable_host: true
        ssl: null
        fields: null
        processors:
          - add_fields:
              target: _temp_
              fields:
                _conf: main
          - add_locale: null
  - id: tcp-fortinet_fortimanager-2e333f65-24ef-47f9-b051-f15ddd1a6349
    name: fortinet_fortimanager
    revision: 1
    type: tcp
    use_output: default
    meta:
      package:
        name: fortinet_fortimanager
        version: 2.15.0
    data_stream:
      namespace: fortinet
    package_policy_id: 2e333f65-24ef-47f9-b051-f15ddd1a6349
    streams:
      - id: tcp-fortinet_fortimanager.log-2e333f65-24ef-47f9-b051-f15ddd1a6349
        data_stream:
          dataset: fortinet_fortimanager.log
          type: logs
        host: '0.0.0.0:7012'
        network: tcp4
        ssl: null
        tags:
          - preserve_original_event
          - forwarded
          - fortinet_fortimanager-log
        publisher_pipeline.disable_host: true
EOH
        destination = "local/elastic-agent.yml"
        change_mode = "restart"
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }

    # Ensure we only run one instance per node
    constraint {
      operator = "distinct_hosts"
      value    = "true"
    }
  }

  # Add update strategy for rolling updates
  update {
    max_parallel     = 1
    min_healthy_time = "30s"
    healthy_deadline = "5m"
    auto_revert      = true
  }
}
