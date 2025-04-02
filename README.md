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

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/nomad-ansible.git
cd nomad-ansible
chmod +x *.sh
./run-playbook.sh
