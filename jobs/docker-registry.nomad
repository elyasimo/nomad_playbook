job "docker-registry" {
  datacenters = ["dum-seclab"]
  type        = "service"

  group "registry" {
    count = 3  # Run on all 3 client nodes for high availability

    # Ensure instances run on different hosts
    constraint {
      operator = "distinct_hosts"
      value    = "true"
    }

    network {
      port "registry" {
        static = 5000
      }
    }

    # Use the host volume for persistent storage
    volume "registry_data" {
      type      = "host"
      read_only = false
      source    = "registry_data"
    }

    task "registry" {
      driver = "docker"

      config {
        image = "registry:2"
        ports = ["registry"]
        volumes = [
          "local/config.yml:/etc/docker/registry/config.yml"
        ]
      }

      volume_mount {
        volume      = "registry_data"
        destination = "/var/lib/registry"
        read_only   = false
      }

      template {
        data = <<EOF
version: 0.1
log:
  level: info
storage:
  filesystem:
    rootdirectory: /var/lib/registry
  delete:
    enabled: true
http:
  addr: :5000
  headers:
    X-Content-Type-Options: [nosniff]
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
EOF
        destination = "local/config.yml"
      }

      resources {
        cpu    = 500
        memory = 512
      }

      service {
        name = "docker-registry"
        port = "registry"
        check {
          type     = "http"
          path     = "/v2/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}

