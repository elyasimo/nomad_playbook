job "cma-extractor" {
  datacenters = ["dum-seclab"]
  type        = "batch"
  
  # Periodic schedule configuration
  periodic {
    crons            = ["*/30 * * * *"]
    prohibit_overlap = true
    time_zone        = "Europe/Zurich"
  }

  group "extractor" {
    count = 1

    # Reference the host volume
    volume "cma_data" {
      type      = "host"
      read_only = false
      source    = "cma_data"
    }

    # Restart policy for the entire group
    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    # Specify how long to wait when stopping the group
    reschedule {
      delay          = "30s"
      delay_function = "exponential"
      max_delay      = "10m"
      unlimited      = false
      attempts       = 3
    }

    ephemeral_disk {
      size = 300
    }

    task "extract" {
      driver = "docker"

      # Increase the kill timeout to allow the task more time to complete
      kill_timeout = "5m"

      # Mount the volume
      volume_mount {
        volume      = "cma_data"
        destination = "/data"
        read_only   = false
      }

      config {
        image = "registry:5000/cma-extractor:latest"
        
        # Command and args if needed
        command = "/bin/bash"
        args    = ["-c", "cd /app && ./extract.sh"]
        
        # Mount local files if needed
        volumes = [
          "local/config.json:/app/config.json"
        ]
      }

      # Template for configuration files
      template {
        data = <<EOF
{
  "source": "cma_database",
  "connection_timeout": 60,
  "retry_attempts": 3,
  "output_dir": "/data",
  "log_level": "info"
}
EOF
        destination = "local/config.json"
      }

      # Environment variables
      env {
        DATA_DIR = "/data"
        LOG_LEVEL = "info"
        MAX_RETRIES = "5"
        TIMEOUT_SECONDS = "300"
        TZ = "Europe/Zurich"
      }

      # Increase resources to ensure the job has enough capacity
      resources {
        cpu    = 1000
        memory = 1024
      }

      # Add logging configuration
      logs {
        max_files     = 10
        max_file_size = 15
      }
    }

    # Optional: Add a cleanup task
    task "cleanup" {
      driver = "docker"
      
      config {
        image   = "alpine:latest"
        command = "/bin/sh"
        args    = ["-c", "find /data -name '*.tmp' -mtime +7 -delete; sleep 30"]
      }
      
      volume_mount {
        volume      = "cma_data"
        destination = "/data"
        read_only   = false
      }
      
      resources {
        cpu    = 200
        memory = 128
      }
      
      lifecycle {
        hook    = "poststop"
        sidecar = false
      }
    }
  }
}

