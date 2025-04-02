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

\`\`\`bash
# Install Python venv package if not already installed
sudo dnf install -y python3-venv

# Create a virtual environment
python3 -m venv ~/ansible-venv

# Activate the virtual environment
source ~/ansible-venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install Ansible and required packages
pip install ansible==2.9.27 netaddr jinja2 PyYAML
\`\`\`

### 2. Clone the Repository

\`\`\`bash
git clone https://github.com/your-org/nomad-ansible.git
cd nomad-ansible
\`\`\`

### 3. Configure Inventory

Edit the `inventory/hosts.yml` file to match your environment. The file should define your Nomad servers, Nomad clients, and Nginx load balancer with their respective IP addresses.

### 4. Configure Variables

Review and modify the `group_vars/all.yml` file to customize your deployment. This file contains configuration for Nomad and Consul versions, datacenter name, encryption keys, and other important settings.

### 5. Make All Shell Scripts Executable

Make all shell scripts in the repository executable:

\`\`\`bash
# Make all shell scripts executable
find . -name "*.sh" -exec chmod +x {} \;
\`\`\`

### 6. Run the Installation Playbook

Run the Ansible playbook to install and configure the cluster:

\`\`\`bash
# Run the playbook
./run-playbook.sh
\`\`\`

When prompted, enter the sudo password for the remote servers.

### 7. Verify the Installation

After the playbook completes, verify that Nomad and Consul are properly installed and running:

\`\`\`bash
# Check Nomad cluster status
./check-nomad.sh

# Check Consul cluster status
./check-consul.sh
\`\`\`

You should see output showing all Nomad servers, Nomad clients, and Consul servers are healthy and connected.

### 8. Deploy Nomad Jobs

Once the infrastructure is verified, deploy the required Nomad jobs:

\`\`\`bash
# Deploy Docker Registry job
nomad job run jobs/docker-registry.nomad

# Wait for the Docker Registry to be fully deployed
sleep 30

# Check Docker Registry job status
nomad job status docker-registry

# Deploy Elastic Agent job
nomad job run jobs/elastic-agent.nomad

# Check Elastic Agent job status
nomad job status elastic-agent
\`\`\`

