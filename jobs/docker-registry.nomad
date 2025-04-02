job "docker-registry" {
  datacenters = ["dum-seclab"]
  type = "service"

  group "registry" {
    count = 3  # Starting with 1 instance for simplicity

    network {
      port "registry" {
        static = 5000  # Using static port for simplicity
      }
    }

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

      template {
        data = <<EOH
version: 0.1
storage:
  filesystem:
    rootdirectory: /var/lib/registry
http:
  addr: 0.0.0.0:5000
  headers:
    X-Content-Type-Options: [nosniff]
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
EOH
        destination = "local/config.yml"
      }

      volume_mount {
        volume      = "registry_data"
        destination = "/var/lib/registry"
        read_only   = false
      }

      resources {
        cpu    = 500
        memory = 256
      }

      # Removed the service block to avoid Consul dependency
    }
  }

  # Simplified update strategy
  update {
    max_parallel     = 1
    min_healthy_time = "30s"
    healthy_deadline = "5m"
    auto_revert      = true
  }
}
