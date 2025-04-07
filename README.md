# Nomad 1.9.7 Cluster Installation Guide

## Overview

This document provides step-by-step instructions for installing and configuring a Nomad 1.9.7 cluster with Consul integration using Ansible. The deployment includes Nomad servers with Consul, Nomad clients with Docker support, and an Nginx load balancer with Elastic Agent stream configuration.

## Architecture

The cluster consists of:
- 3 Nomad server nodes with Consul (high availability setup)
- 3 Nomad client nodes (with Docker support)
- 1 Nginx load balancer (for Nomad UI, Consul UI, Elastic Agent streams and other services)

## Prerequisites

### System Requirements

- **Servers**: 7 VMs running RHEL/CentOS 7 or 8
- **Memory**: Minimum 4GB RAM per node
- **CPU**: Minimum 2 cores per node
- **Storage**: Minimum 20GB free space
- **Network**: All nodes must be able to communicate with each other

### Software Requirements

- **Ansible**: Version 2.9 or higher on the control node
- **SSH**: Access to all nodes with sudo privileges
- **Python**: Version 3.6 or higher on all nodes

## Installation Steps

### 1. Set Up the Control Node

First, set up your control node with Python virtual environment and Ansible:

#### Install Python venv package if not already installed

```bash
sudo dnf install -y python3-venv
```

#### Create a virtual environment

```bash
sudo python3 -m venv /opt/ansible-venv
```

#### Activate the virtual environment

```bash
source /opt/ansible-venv/bin/activate
```

#### Upgrade pip

```bash
pip install --upgrade pip
```

#### Install Ansible and required packages
```bash
pip install ansible==2.9.27 netaddr jinja2 PyYAML
```


### 2. Clone the Repository

```bash
git clone ssh://git@code.swisscom.com:2222/swisscom/managed-security-service/sp/orchestration/ansible-nomad-deployment.git
cd ansible-nomad-deployment
```
### 3. Set Up SSH Key-Based Access
To allow Ansible to connect to all nodes without password prompts, set up SSH key-based authentication.
Generate an SSH key pair (if not already created)
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
Press Enter to accept the default location (~/.ssh/id_rsa) and leave the passphrase empty (unless otherwise required).

Copy the public key to each target node
Run the following command for each node listed in your inventory:
```bash
ssh-copy-id user@target-node
```

Replace:
    technical_user with the name of your technical user (must have sudo rights)
    target-node with the IP address or hostname of the remote server

This setup allows Ansible to connect without requiring password prompts.

Verify the connection
You can verify SSH access works correctly using:
```bash
ssh technical_user@target-node
```
### 4. Configure Inventory

Edit the `inventory/hosts.yml` file to match your environment. The file should define your Nomad servers, Nomad clients, and Nginx load balancer with their respective IP addresses.

### 5. Configure Variables

Review and modify the `group_vars/all.yml` file to customize your deployment. This file contains configuration for Nomad and Consul versions, datacenter name, encryption keys, and other important settings.

### 6. Make All Shell Scripts Executable

Make all shell scripts in the repository executable:

# Make all shell scripts executable
```bash
find . -name "*.sh" -exec chmod +x {} \;
```

### 7. Run the Installation Playbook

Run the Ansible playbook to install and configure the cluster:

#### Run the playbook
```bash
./run-playbook.sh
```

When prompted, enter the sudo password for the remote servers.

### 8. Verify the Installation

After the playbook completes, verify that Nomad and Consul are properly installed and running:

#### Check Nomad cluster status
```bash
./check-nomad.sh
```

#### Check Consul cluster status
```bash
./check-consul.sh
```


You should see output showing all Nomad servers, Nomad clients, and Consul servers are healthy and connected.

### 9. Deploy Nomad Jobs

Once the infrastructure is verified, deploy the required Nomad jobs:

#### Deploy Docker Registry job
```bash
nomad job run jobs/docker-registry.nomad
```

#### Wait for the Docker Registry to be fully deployed
```bash
sleep 30
```

#### Check Docker Registry job status
```bash
nomad job status docker-registry
```

#### Deploy Elastic Agent job
```bash
nomad job run jobs/elastic-agent.nomad
```

#### Check Elastic Agent job status
```bash
nomad job status elastic-agent
```


